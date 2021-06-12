import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class PlanifitScanBloC extends BaseBloC {
  final PlanifitUtils planifitUtils;
  final SharedPreferencesManager _sharedPreferencesManager;

  PlanifitScanBloC(this.planifitUtils, this._sharedPreferencesManager);

  @override
  void dispose() {
    _scanController.close();
  }

  BehaviorSubject<WatchScanStatus> _scanController = new BehaviorSubject();

  Stream<WatchScanStatus> get scanResult => _scanController.stream;

  BehaviorSubject<WatchConnectedStatus> _connectController =
      new BehaviorSubject();

  Stream<WatchConnectedStatus> get connectResult => _connectController.stream;

  Map<String, BleDevice> bleMap = {};

  void init() async {
    planifitUtils.listenScan((BleDevice model) {
      bleMap[model.address] = model;
    });
    scan();
  }

  void scan() async {
    planifitUtils.scan(isScanning: (bool scanning) {
      _scanController.sinkAddSafe(WatchScanStatus.Scanning);
      Future.delayed(Duration(seconds: 5), () async {
        await stopScan();
        _scanController.sinkAddSafe(WatchScanStatus.Stopped);
      });
    });
    _scanController.sinkAddSafe(WatchScanStatus.Scanning);
  }

  Future<void> stopScan() async => await planifitUtils.stopScan();

  Future<WatchConnectedStatus> connect({String address}) async {
    try {
      final WatchConnectedStatus result =
      await planifitUtils.connect(address: address);

      if(result == WatchConnectedStatus.Connected){
        await _sharedPreferencesManager.setStringValue(SharedKey.lastConnectedDevice, address);
      }
      return result;
    } catch (e) {
      print("Failed to check if is scanning: '${e.message}'.");
      return WatchConnectedStatus.Disconnected;
    }
  }
}
