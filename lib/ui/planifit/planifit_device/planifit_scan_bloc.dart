import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_constanst.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class PlanifitScanBloC extends BaseBloC {
  @override
  void dispose() {
    _scanController.close();
    _devicesDataController.close();
    _eventsSubscription.cancel();
    _connectController.close();
  }

  BehaviorSubject<BleDevice> _connectController = new BehaviorSubject();

  Stream<BleDevice> get connectResult => _connectController.stream;

  BehaviorSubject<WatchScanStatus> _scanController = new BehaviorSubject();

  Stream<WatchScanStatus> get scanResult => _scanController.stream;

  BehaviorSubject<Map<String, BleDevice>> _devicesDataController =
      new BehaviorSubject();

  Stream<Map<String, BleDevice>> get devicesDataResult =>
      _devicesDataController.stream;

  StreamSubscription _eventsSubscription;

  void init() async {
    _eventsSubscription = planifitEventsStream.listen((eventData) {
      final key = eventData[eventChannelSinkKey];
      if (key == LE_SCAN_CALLBACK) {
        final model = BleDevice.fromJson(eventData);
        final map = _devicesDataController.value ?? Map<String, BleDevice>();
        map[model.address] = model;
        _devicesDataController.sinkAddSafe(map);
      }
    });
    scan();
  }

  void connect(BleDevice device) async {
    try {
      final result = await platform.invokeMethod(CONNECT, device.address);
      _connectController.sinkAddSafe(result == 200 ? device : null);
    }  catch (e) {
      print("Failed to check if is scanning: '${e.message}'.");
      _connectController.sinkAddSafe(null);
    }
  }

  void scan() async {
    try {
      final result = await platform.invokeMethod(START_SCAN);
      _scanController.sinkAddSafe(
          result == 200 ? WatchScanStatus.Scanning : WatchScanStatus.Stopped);
      await Future.delayed(Duration(milliseconds: 10000), () async {
        await stopScan();
      });
    } catch (e) {
      print("Failed to start scan: '${e.message}'.");
      _scanController.sinkAddSafe(WatchScanStatus.Stopped);
    }
  }

  Future<void> stopScan() async {
    if (_scanController.value == WatchScanStatus.Stopped) return;

    try {
      await platform.invokeMethod(STOP_SCAN, "stop");
    } catch (e) {
      print("Failed to stop scan: '${e.message}'.");
    }
    final map = _devicesDataController.value ?? Map<String, BleDevice>();
    _scanController.sinkAddSafe(map.values.toList().isNotEmpty ? WatchScanStatus.Discovered : WatchScanStatus.Stopped);
  }
}
