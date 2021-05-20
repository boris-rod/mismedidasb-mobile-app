import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_constanst.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../../enums.dart';

class PlanifitHomeBloC extends BaseBloC {
  final SharedPreferencesManager _sharedPreferencesManager;

  PlanifitHomeBloC(this._sharedPreferencesManager);

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _connectController.close();
  }

  StreamSubscription _eventsSubscription;

  BehaviorSubject<WatchConnectedStatus> _connectController =
      new BehaviorSubject();

  Stream<WatchConnectedStatus> get connectResult => _connectController.stream;

  void init() async {
    final supported = await supportBLE();
    final enabled = await iSBLEEnabled();

    if (supported && enabled) {
      connect();

      planifitEventsStream = eventsStream.receiveBroadcastStream([]);

      _eventsSubscription = planifitEventsStream.listen((eventData) {
        final key = eventData[eventChannelSinkKey];
        if (key == BLOOD_PRESSURE_CALLBACK) {
          final model = BloodPressure.fromJson(eventData);
          print("BLOOD PRESSURE HIGH ${model.highPressure.toString()}");
        } else if (key == RATE_CALLBACK) {
          final model = Rate.fromJson(eventData);
          print("Rate ${model.tempRate.toString()}");
        } else if (key == STEP_CHANGE_CALLBACK) {
          final model = StepOneDayAllInfo.fromJson(eventData);
          print("STEPS ${model.walkSteps.toString()}");
        }
      });
    }
  }

  void connect({String address}) async {
    try {
      final lastConnectedDevice = address ?? await _sharedPreferencesManager
          .getStringValue(SharedKey.lastConnectedDevice, defValue: "");

      if (lastConnectedDevice.isNotEmpty) {
        final result =
            await platform.invokeMethod(CONNECT, lastConnectedDevice);
        _connectController.sinkAddSafe(result == 200
            ? WatchConnectedStatus.Connected
            : WatchConnectedStatus.Disconnected);
        print("Connected: ${result.toString()}");
      } else {
        _connectController.sinkAddSafe(WatchConnectedStatus.Disconnected);
      }
    } on PlatformException catch (e) {
      print("Failed to check if is scanning: '${e.message}'.");
      _connectController.sinkAddSafe(WatchConnectedStatus.Disconnected);
    }
  }
}
