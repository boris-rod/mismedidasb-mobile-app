import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../enums.dart';

class PlanifivePaymentBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _prefs;

  PlanifivePaymentBloC(this._iUserRepository, this._prefs);

  @override
  void dispose() {
    disposeLoadingBloC();
    _productsController.close();
    _paymentController.close();
    _showSaveCardController.close();
    _showSavedCardsController.close();
    _cardsController.close();
    _paymentProgressController.close();
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
  }

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

  BehaviorSubject<PaymentProgress> _paymentProgressController =
      new BehaviorSubject();

  Stream<PaymentProgress> get paymentProgressResult =>
      _paymentProgressController.stream;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;
  final List<String> _productLists = ['p500', 'p2000', 'p3500'];
  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  bool productsLoaded = false;
  bool cardsLoaded = true;

  void loadProducts() async {
    isLoading = true;
    if (Platform.isAndroid) {
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
    } else {
      isLoading = false;
    }
  }

  String _clientSecret = "";
  int productId;
  PaymentMethod _paymentMethod;
  PaymentIntentResult _paymentIntent;

  void initPayment() async {
    if (Platform.isAndroid)
      StripePayment.setOptions(StripeOptions(
        publishableKey: RemoteConstants.stripe_public_key,
      ));
    else {
      await initPlatformState();
    }
  }

  Future<void> initPlatformState() async {
    isLoading = true;
    FlutterInappPurchase.instance.initConnection;
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      final List<PurchasedItem> pendings =
          await FlutterInappPurchase.instance.getPendingTransactionsIOS();
      if (pendings.isNotEmpty) {
        _paymentProgressController.sinkAddSafe(PaymentProgress.VERIFYING);
        await Future.forEach<PurchasedItem>(pendings, (pending) async {
          final res = await _iUserRepository
              .postPurchaseDetails(pending.transactionReceipt);
          if (res is ResultSuccess<List<OrderModel>>) {
            print("Response orders ${res.value.length}");
            await FlutterInappPurchase.instance
                .finishTransactionIOS(pending.transactionId);
          }
        });
      }
      if (productItem.transactionReceipt != null &&
          productItem.transactionReceipt.isNotEmpty &&
          productItem.transactionStateIOS.index == 1) {
        await deliverProduct(productItem);
      } else {
        _paymentProgressController.sinkAddSafe(PaymentProgress.WAITING_ACTION);
        isLoading = false;
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      _paymentProgressController.sinkAddSafe(PaymentProgress.WAITING_ACTION);
      print('purchase-error: $purchaseError');
      isLoading = false;
    });
    await _getProducts();
    isLoading = false;
  }

  Future<void> _getProducts() async {
    _paymentProgressController.sinkAddSafe(PaymentProgress.GETTING_PRODUCTS);
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    List<PlanifiveProductsModel> planiProducts = [];
    items.forEach((element) {
      planiProducts.add(PlanifiveProductsModel(
          idStr: element.productId,
          name: element.title,
          price: double.tryParse(element.price),
          description: element.description));
    });
    planiProducts.sort((a, b) => a.price.compareTo(b.price));
    _productsController.sinkAddSafe(planiProducts);
    Future.delayed(Duration(milliseconds: 100), () {
      _paymentProgressController.sinkAddSafe(PaymentProgress.WAITING_ACTION);
    });
  }

  Future<void> deliverProduct(PurchasedItem purchasedItem) async {
    _paymentProgressController.sinkAddSafe(PaymentProgress.VERIFYING);
    final res = await _iUserRepository
        .postPurchaseDetails(purchasedItem.transactionReceipt);
    if (res is ResultSuccess<List<OrderModel>>) {
      print("Response orders ${res.value.length}");
      await Future.forEach<OrderModel>(res.value, (element) async {
        await FlutterInappPurchase.instance
            .finishTransactionIOS(element.externalId);
      });
      _paymentController.sinkAddSafe(true);
    } else
      showErrorMessage(res);
    _paymentProgressController.sinkAddSafe(PaymentProgress.READY);
    isLoading = false;
  }

  void buyConsumableProduct(PlanifiveProductsModel model) async {
    _paymentProgressController.sinkAddSafe(PaymentProgress.BUYING);
    isLoading = true;
    FlutterInappPurchase.instance.requestPurchase(model.idStr).then(
        (value) => {
              print(value.toString()),
            }, onError: (err) {
      print(err.toString());
    });
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
}
