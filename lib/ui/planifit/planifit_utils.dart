import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';

class PlanifitUtils {
  MethodChannel _platform;
  EventChannel _eventsStream;
  Stream _planifitEventsStream;
  StreamSubscription _eventsSubscription;

  final eventChannelSinkKey = "EVENT_CHANNEL_SINK_TYPE_KEY";

  //Channel methods
  final START_SCAN = "start_scan";
  final STOP_SCAN = "stop_scan";
  final CONNECT = "connect";
  final DISCONNECT = "disconnect";
  final IS_SUPPORT_BLE = "is_support_ble";
  final IS_BLE_ENABLED = "is_ble_enabled";

  //Channel event
  final LE_SCAN_CALLBACK = "LeScanCallback";
  final BLOOD_PRESSURE_CALLBACK = "mOnBloodPressureListener";
  final RATE_CALLBACK = "mOnRateListener";
  final STEP_CHANGE_CALLBACK = "mOnStepChangeListener";
  final RATE24_CALLBACK = "mOnRateOf24HourListener";

  PlanifitUtils() {
    // _platform = MethodChannel('watch.metriri.com/actions_from_flutter');
    // _eventsStream = EventChannel('watch.metriri.com/actions_from_native');
    // _planifitEventsStream = _eventsStream.receiveBroadcastStream([]);
    // _eventsSubscription = _planifitEventsStream.listen((eventData) {});
    // initListeners();
  }

  void initListeners() {
    _eventsSubscription = _planifitEventsStream.listen((eventData) {
      final key = eventData[eventChannelSinkKey];
      if (key == LE_SCAN_CALLBACK && _scanCallBack != null) {
        final model = BleDevice.fromJson(eventData);
        _scanCallBack(model);
        print("BleDevice ${model.name}");
      } else if (key == BLOOD_PRESSURE_CALLBACK &&
          _bloodPressureCallBack != null) {
        final model = BloodPressure.fromJson(eventData);
        _bloodPressureCallBack(model);
        print("BloodPressure ${model.highPressure.toString()}");
      } else if (key == RATE_CALLBACK && _rateCallBack != null) {
        final model = Rate.fromJson(eventData);
        _rateCallBack(model);
        print("Rate ${model.tempRate.toString()}");
      } else if (key == STEP_CHANGE_CALLBACK &&
          _stepOneDayAllInfoCallBack != null) {
        final model = StepOneDayAllInfo.fromJson(eventData);
        _stepOneDayAllInfoCallBack(model);
        print("StepOneDayAllInfo ${model.walkSteps.toString()}");
      } else if (key == RATE24_CALLBACK && _rate24CallBack != null) {
        final model = Rate24.fromJson(eventData);
        _rate24CallBack(model);
        print("Rate24 ${model.maxHeartRateValue.toString()}");
      }
    });
  }

  void close() {
    _eventsSubscription.cancel();
  }

  Future<bool> supportBLE() async {
    try {
      final result = await _platform.invokeMethod(IS_SUPPORT_BLE);
      return result;
    } catch (e) {
      print("Failed to start scan: '${e.message}'.");
      return false;
    }
  }

  Future<bool> iSBLEEnabled() async {
    try {
      final result = await _platform.invokeMethod(
        IS_BLE_ENABLED,
      );
      return result;
    } catch (e) {
      print("Failed to start scan: '${e.message}'.");
      return false;
    }
  }

  Future<void> scan({ValueChanged<WatchScanStatus> scanResult}) async {
    try {
      scanResult(WatchScanStatus.Scanning);

      FlutterBlue flutterBlue = FlutterBlue.instance;
      flutterBlue.startScan(timeout: Duration(seconds: 5));
      flutterBlue.scanResults.listen((results) async {
        await flutterBlue.stopScan();

        final result = await _platform.invokeMethod(START_SCAN);
        scanResult(
            result == 200 ? WatchScanStatus.Scanning : WatchScanStatus.Stopped);
        await Future.delayed(Duration(milliseconds: 10000), () async {
          await stopScan();
        });
      });
    } catch (e) {
      await stopScan();
      scanResult(WatchScanStatus.Stopped);
    }
  }

  Future<bool> stopScan() async {
    try {
      await _platform.invokeMethod(STOP_SCAN);
      return true;
    } catch (e) {
      print("Failed to stop scan: '${e.message}'.");
      return false;
    }
  }

  Future<WatchConnectedStatus> connect({String address}) async {
    try {
      final result = await _platform.invokeMethod(CONNECT, address);
      return result == 200
          ? WatchConnectedStatus.Connected
          : WatchConnectedStatus.Disconnected;
    } catch (e) {
      return WatchConnectedStatus.Disconnected;
    }
  }

  Future<bool> disconnect() async {
    try {
      final result = await _platform.invokeMethod(DISCONNECT);
      return result == 200;
    } catch (e) {
      return false;
    }
  }

  ///Listeners
  ValueChanged<BleDevice> _scanCallBack;
  ValueChanged<BloodPressure> _bloodPressureCallBack;
  ValueChanged<Rate> _rateCallBack;
  ValueChanged<Rate24> _rate24CallBack;
  ValueChanged<StepOneDayAllInfo> _stepOneDayAllInfoCallBack;

  void listenScan(ValueChanged<BleDevice> callback) => _scanCallBack = callback;

  void listenBloodPressure(ValueChanged<BloodPressure> callback) =>
      _bloodPressureCallBack = callback;

  void listenRate(ValueChanged<Rate> callback) => _rateCallBack = callback;

  void listenRate24(ValueChanged<Rate24> callback) =>
      _rate24CallBack = callback;

  void listenStepOneDayAllInfo(ValueChanged<StepOneDayAllInfo> callback) =>
      _stepOneDayAllInfoCallBack = callback;
}
