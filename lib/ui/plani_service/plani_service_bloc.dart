import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class PlaniServiceBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;
  final ILNM _ilnm;

  PlaniServiceBloC(this._iUserRepository, this._ilnm);

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
    _subscriptionsController.close();
  }

  BehaviorSubject<List<SubscriptionModel>> _subscriptionsController =
      new BehaviorSubject();

  Stream<List<SubscriptionModel>> get subscriptionsResult =>
      _subscriptionsController.stream;

  UserModel _userModel;

  void loadData(UserModel userModel) async {
    isLoading = true;
    _userModel = userModel;
    final res = await _iUserRepository.getSubscriptions();
    if (res is ResultSuccess<List<SubscriptionModel>>) {
      List<SubscriptionModel> list = updateSubscriptions(userModel, res.value);
      _subscriptionsController.sinkAddSafe(list);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void buyOffer1() async {
    isLoading = true;
    final res = await _iUserRepository.buySubscriptionsOffer1();
    if (res is ResultSuccess<bool>) {
      final resProfile = await _iUserRepository.getProfile();
      if (resProfile is ResultSuccess<UserModel>) {
        List<SubscriptionModel> list = updateSubscriptions(
            resProfile.value, _subscriptionsController?.value ?? []);
        _subscriptionsController.sinkAddSafe(list);
      }
      showErrorMessage(res);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void buySubscription(SubscriptionModel model) async {
    isLoading = true;
    final res = await _iUserRepository.buySubscription(model.id);
    if (res is ResultSuccess<bool>) {
      if (model.product == RemoteConstants.subscription_virtual_assessor) {
        await _ilnm.cancelAll();
        await _ilnm.initReminders();
        final resProfile = await _iUserRepository.getProfile();
        if (resProfile is ResultSuccess<UserModel>) {
          List<SubscriptionModel> list = updateSubscriptions(
              resProfile.value, _subscriptionsController?.value ?? []);
          _subscriptionsController.sinkAddSafe(list);
        }
        showErrorMessage(res);
      }
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  List<SubscriptionModel> updateSubscriptions(
      UserModel userModel, List<SubscriptionModel> list) {
    list.forEach((element) {
      if (element.product == RemoteConstants.subscription_virtual_assessor) {
        element.name = "Plani";
        element.description =
            "Recordatorios y sugenrencias de planificación de comidas.";
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product ==
                    RemoteConstants.subscription_virtual_assessor, orElse: () {
              return null;
            })?.isActive ??
            false;
      } else if (element.product == RemoteConstants.subscription_report_food) {
        element.name = "Reporte alimenticio";
        element.description = "Reporte semanal sobre los alimentos ingeridos.";
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product == RemoteConstants.subscription_report_food,
                orElse: () {
              return null;
            })?.isActive ??
            false;
      } else if (element.product ==
          RemoteConstants.subscription_report_nutrition) {
        element.name = "Reporte nutricional";
        element.description =
            "Reporte semanal sobre la información nutricional de los alimentos ingeridos.";
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product == RemoteConstants.subscription_report_food,
                orElse: () {
              return null;
            })?.isActive ??
            false;
      } else
        element.name = element.product;
    });
    return list;
  }
}
