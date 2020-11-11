import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PlanifivePaymentBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;

  PlanifivePaymentBloC(this._iUserRepository);

  BehaviorSubject<List<PlanifiveProductsModel>> _productsController =
      new BehaviorSubject();

  Stream<List<PlanifiveProductsModel>> get productsResult =>
      _productsController.stream;

  BehaviorSubject<List<CreditCardModel>> _cardsController =
      new BehaviorSubject();

  Stream<List<CreditCardModel>> get cardsResult => _cardsController.stream;

  BehaviorSubject<bool> _paymentController = new BehaviorSubject();

  Stream<bool> get paymentResult => _paymentController.stream;

  BehaviorSubject<bool> _showSaveCardController = new BehaviorSubject();

  Stream<bool> get showSaveCardResult => _showSaveCardController.stream;

  BehaviorSubject<bool> _showSavedCardsController = new BehaviorSubject();

  Stream<bool> get showSavedCardsResult => _showSavedCardsController.stream;

  bool productsLoaded = false;
  bool cardsLoaded = true;

  @override
  void dispose() {
    disposeLoadingBloC();
    _productsController.close();
    _paymentController.close();
    _showSaveCardController.close();
    _showSavedCardsController.close();
    _cardsController.close();
  }

  void loadProducts() async {
    isLoading = true;
    _iUserRepository.getPaymentMethods().then((res) {
      _cardsController.sinkAddSafe((res as ResultSuccess).value);
      cardsLoaded = true;
      if (productsLoaded) isLoading = false;
    }).catchError((err) {
      cardsLoaded = true;
      if (productsLoaded) isLoading = false;
      showErrorMessage(err);
    });

    _iUserRepository.getPlanifiveProducts().then((res) {
      _productsController.sinkAddSafe((res as ResultSuccess).value);
      productsLoaded = true;
      if (cardsLoaded) isLoading = false;
    }).catchError((err) {
      productsLoaded = true;
      if (cardsLoaded) isLoading = false;
      showErrorMessage(err);
    });
  }

  String _clientSecret = "";
  int productId;
  PaymentMethod _paymentMethod;
  PaymentIntentResult _paymentIntent;

  void initPayment() async {
    StripePayment.setOptions(StripeOptions(
      publishableKey: RemoteConstants.stripe_public_key,
    ));
  }

  void addPayment(int productId) async {
    this.productId = productId;
    final savedCardsList = _cardsController?.value ?? [];
    if (savedCardsList.isNotEmpty) {
      _showSavedCardsController.sinkAddSafe(true);
    } else {
      payWithCardFormRequest();
    }
  }

  void payWithCardFormRequest() async {
    isLoading = true;
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) async {
      _paymentMethod = paymentMethod;
      _showSaveCardController.sinkAddSafe(true);
    }).catchError((err) {
      isLoading = false;
      print(err.toString());
    });
  }

  void confirmPayment(bool saveCard, {String paymentMethodId}) async {
    if (paymentMethodId != null) isLoading = true;
    final res = await _iUserRepository.stripePaymentAction(productId, saveCard);
    if (res is ResultSuccess<String>) {
      _clientSecret = res.value;

      PaymentIntent pi = PaymentIntent(
        clientSecret: _clientSecret,
        paymentMethodId: paymentMethodId ?? _paymentMethod.id,
      );
      await StripePayment.confirmPaymentIntent(
        pi,
      ).then((paymentIntent) async {
        _paymentIntent = paymentIntent;
        _paymentController.sinkAddSafe(true);
        isLoading = false;
      }).catchError((err) {
        print(err.toString());
        isLoading = false;
      });
    } else
      showErrorMessage(res);
  }

  void removeCardFromSavedList(CreditCardModel creditCardModel) async {
    isLoading = true;
    final res = await _iUserRepository
        .deletePaymentMethod(creditCardModel.paymentMethodId);
    if (res is ResultSuccess<bool>) {
        final savedCardsList = _cardsController?.value ?? [];
      savedCardsList.removeWhere((element) =>
          element.paymentMethodId == creditCardModel.paymentMethodId);
      _cardsController.sinkAddSafe(savedCardsList);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void nativePay() async {
    StripePayment.canMakeNativePayPayments([]);
    StripePayment.paymentRequestWithNativePay(
        androidPayOptions:
            AndroidPayPaymentRequest(currencyCode: null, totalPrice: null),
        applePayOptions: ApplePayPaymentOptions());
  }

// void payWithCardRequest(CreditCardModel creditCardModel) async {
//   isLoading = true;
//   CreditCard creditCard = CreditCard(
//       cardId: creditCardModel.paymentMethodId,
//       country: creditCardModel.country,
//       expMonth: creditCardModel.expMonth,
//       expYear: creditCardModel.expYear,
//       funding: creditCardModel.funding,
//       last4: creditCardModel.last4,
//       number: "4242424242424242"
//   );
//   final PaymentMethodRequest paymentMethodRequest = PaymentMethodRequest(
//       card: creditCard,
//       token: Token(
//           card: creditCard,
//           tokenId: creditCardModel.paymentMethodId
//       )
//   );
//   StripePayment.createPaymentMethod(paymentMethodRequest)
//       .then((paymentMethod) async {
//     _paymentMethod = paymentMethod;
//     confirmPayment(true);
//   }).catchError((err) {
//     isLoading = false;
//     print(err.toString());
//   });
// }

}
