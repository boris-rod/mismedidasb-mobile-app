import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/res/R.dart';
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
    _coinsController.close();
  }

  BehaviorSubject<List<SubscriptionModel>> _subscriptionsController =
      new BehaviorSubject();

  Stream<List<SubscriptionModel>> get subscriptionsResult =>
      _subscriptionsController.stream;

  BehaviorSubject<int> _coinsController = new BehaviorSubject();

  Stream<int> get coinsResult => _coinsController.stream;

  void loadData(UserModel userModel) async {
    isLoading = true;
    final res = await _iUserRepository.getSubscriptions();
    if (res is ResultSuccess<List<SubscriptionModel>>) {
      List<SubscriptionModel> list = updateSubscriptions(userModel, res.value);
      _subscriptionsController.sinkAddSafe(list);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void loadCoins() async {
    final res = await _iUserRepository.getScores();
    if (res is ResultSuccess<ScoreModel>) {
      _coinsController.sinkAddSafe(res.value.coins);
    }
  }

  void buyOffer1() async {
    isLoading = true;
    final res = await _iUserRepository.buySubscriptionsOffer1();
    if (res is ResultSuccess<bool>) {
      final resProfile = await _iUserRepository.getProfile();
      if (resProfile is ResultSuccess<UserModel>) {
        loadCoins();
        List<SubscriptionModel> list = updateSubscriptions(
            resProfile.value, _subscriptionsController?.value ?? []);
        _subscriptionsController.sinkAddSafe(list);
      } else
        showErrorMessage(resProfile);
    } else if (res is ResultError &&
        (res as ResultError).code == RemoteConstants.code_unprocessable) {
      Fluttertoast.showToast(
        msg: R.string.noEnoughCoinsToActivateService,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void buySubscription(SubscriptionModel model) async {
    isLoading = true;
    final res = await _iUserRepository.buySubscription(model.id);
    if (res is ResultSuccess<bool>) {
      loadCoins();
      if (model.product == RemoteConstants.subscription_virtual_assessor) {
        await _ilnm.cancelAll();
        await _ilnm.initReminders();
      }
      final resProfile = await _iUserRepository.getProfile();
      if (resProfile is ResultSuccess<UserModel>) {
        List<SubscriptionModel> list = updateSubscriptions(
            resProfile.value, _subscriptionsController?.value ?? []);
        _subscriptionsController.sinkAddSafe(list);
      } else
        showErrorMessage(resProfile);
    } else if (res is ResultError &&
        (res as ResultError).code == RemoteConstants.code_unprocessable) {
      Fluttertoast.showToast(
        msg: R.string.noEnoughCoinsToActivateService,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  List<SubscriptionModel> updateSubscriptions(
      UserModel userModel, List<SubscriptionModel> list) {
    list.forEach((element) {
      if (element.product == RemoteConstants.subscription_virtual_assessor) {
        element.name = R.string.plani;
        element.description = R.string.planiDescription;
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product ==
                    RemoteConstants.subscription_virtual_assessor, orElse: () {
              return null;
            })?.isActive ??
            false;
        element.validAt = userModel.subscriptions.firstWhere(
            (subs) =>
                subs.product == RemoteConstants.subscription_virtual_assessor,
            orElse: () {
          return null;
        })?.validAt;
      } else if (element.product == RemoteConstants.subscription_report_food) {
        element.name = R.string.foodReport;
        element.description = R.string.foodReportDescription;
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product == RemoteConstants.subscription_report_food,
                orElse: () {
              return null;
            })?.isActive ??
            false;
        element.validAt = userModel.subscriptions.firstWhere(
            (subs) => subs.product == RemoteConstants.subscription_report_food,
            orElse: () {
          return null;
        })?.validAt;
      } else if (element.product ==
          RemoteConstants.subscription_report_nutrition) {
        element.name = R.string.nutritionalReport;
        element.description = R.string.nutritionalReportDescription;
        element.isActive = userModel.subscriptions.firstWhere(
                (subs) =>
                    subs.product ==
                    RemoteConstants.subscription_report_nutrition, orElse: () {
              return null;
            })?.isActive ??
            false;
        element.validAt = userModel.subscriptions.firstWhere(
            (subs) =>
                subs.product == RemoteConstants.subscription_report_nutrition,
            orElse: () {
          return null;
        })?.validAt;
      } else
        element.name = element.product;
    });
    return list;
  }
}
