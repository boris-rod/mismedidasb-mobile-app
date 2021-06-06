import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_model_UI.dart';
import 'package:mismedidasb/ui/planifit/planifit_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../../enums.dart';

class PlanifitHomeBloC extends BaseBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final PlanifitUtils planifitUtils;

  PlanifitHomeBloC(this._sharedPreferencesManager, this.planifitUtils);

  BehaviorSubject<PlanifitHomeModelUI> _mainController = new BehaviorSubject();

  Stream<PlanifitHomeModelUI> get mainResult => _mainController.stream;

  @override
  void dispose() {
    // planifitUtils.close();
    _mainController.close();
  }

  PlanifitHomeModelUI planifitHomeModelUI = PlanifitHomeModelUI(
      bleSupported: false,
      bleEnabled: false,
      connectedStatus: WatchConnectedStatus.Disconnected,
      selectedTab: 0);

  void get refreshData => _mainController.sinkAddSafe(planifitHomeModelUI);

  void init() async {
    // final supported = await planifitUtils.supportBLE();
    // if (!supported) {
    //   Fluttertoast.showToast(
    //       msg: "BLE no soportado!",
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       toastLength: Toast.LENGTH_LONG);
    //   return;
    // }
    // final enabled = await planifitUtils.iSBLEEnabled();
    // if (!enabled) {
    //   Fluttertoast.showToast(
    //       msg: "BLE no habilitado!",
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       toastLength: Toast.LENGTH_LONG);
    //   return;
    // }

    planifitHomeModelUI = PlanifitHomeModelUI(
        bleSupported: true,
        bleEnabled: true,
        connectedStatus: WatchConnectedStatus.Disconnected,
        selectedTab: 0);

    // planifitUtils.listenBloodPressure((BloodPressure model) {
    //   print("BLOOD PRESSURE HIGH ${model.highPressure.toString()}");
    // });
    //
    // planifitUtils.listenRate((Rate model) {
    //   print("Rate ${model.tempRate.toString()}");
    // });
    //
    // planifitUtils.listenStepOneDayAllInfo((StepOneDayAllInfo model) {
    //   print("STEPS ${model.walkSteps.toString()}");
    // });
    //
    // planifitUtils.listenRate24((Rate24 model) {
    //   print("Rate24 ${model.maxHeartRateValue.toString()}");
    // });

    refreshData;
  }

  void disconnect() async {
    final result = await planifitUtils.disconnect();
    planifitHomeModelUI.connectedStatus = result
        ? WatchConnectedStatus.Disconnected
        : WatchConnectedStatus.Connected;
    refreshData;
  }
}
