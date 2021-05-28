import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../../enums.dart';

class PlanifitHomeBloC extends BaseBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final PlanifitUtils planifitUtils;

  PlanifitHomeBloC(this._sharedPreferencesManager, this.planifitUtils);

  @override
  void dispose() {
    _eventsSubscription.cancel();
    planifitUtils.close();
    _connectController.close();
  }

  StreamSubscription _eventsSubscription;

  BehaviorSubject<WatchConnectedStatus> _connectController =
      new BehaviorSubject();

  Stream<WatchConnectedStatus> get connectResult => _connectController.stream;

  void init() async {
    final supported = await planifitUtils.supportBLE();
    if (!supported) {
      Fluttertoast.showToast(
          msg: "BLE no soportado!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    final enabled = await planifitUtils.iSBLEEnabled();
    if (!enabled) {
      Fluttertoast.showToast(
          msg: "BLE no habilitado!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    planifitUtils.listenBloodPressure((BloodPressure model) {
      print("BLOOD PRESSURE HIGH ${model.highPressure.toString()}");
    });

    planifitUtils.listenRate((Rate model) {
      print("Rate ${model.tempRate.toString()}");
    });

    planifitUtils.listenStepOneDayAllInfo((StepOneDayAllInfo model) {
      print("STEPS ${model.walkSteps.toString()}");
    });

    planifitUtils.listenRate24((Rate24 model) {
      print("Rate24 ${model.maxHeartRateValue.toString()}");
    });

    connect();
  }

  void connect({String address}) async {
    try {
      final lastConnectedDevice = address ??
          await _sharedPreferencesManager
              .getStringValue(SharedKey.lastConnectedDevice, defValue: "");

      if (lastConnectedDevice.isNotEmpty) {
        final WatchConnectedStatus result =
            await planifitUtils.connect(address: lastConnectedDevice);
        _connectController.sinkAddSafe(result);
        print("Connected: ${result.toString()}");
      } else {
        _connectController.sinkAddSafe(WatchConnectedStatus.Disconnected);
      }
    } catch (e) {
      print("Failed to check if is scanning: '${e.message}'.");
      _connectController.sinkAddSafe(WatchConnectedStatus.Disconnected);
    }
  }
}
