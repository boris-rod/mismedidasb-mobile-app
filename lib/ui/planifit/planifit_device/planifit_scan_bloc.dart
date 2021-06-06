import 'dart:async';

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
    _devicesDataController.close();
  }

  BehaviorSubject<WatchScanStatus> _scanController = new BehaviorSubject();

  Stream<WatchScanStatus> get scanResult => _scanController.stream;

  BehaviorSubject<Map<String, BleDevice>> _devicesDataController =
      new BehaviorSubject();

  Stream<Map<String, BleDevice>> get devicesDataResult =>
      _devicesDataController.stream;

  BehaviorSubject<WatchConnectedStatus> _connectController =
  new BehaviorSubject();

  Stream<WatchConnectedStatus> get connectResult => _connectController.stream;

  void init() async {
    planifitUtils.listenScan((BleDevice model) {
      final map = _devicesDataController.value ?? Map<String, BleDevice>();
      map[model.address] = model;
      _devicesDataController.sinkAddSafe(map);
    });
    scan();
  }

  void scan() async {
    planifitUtils.scan(scanResult: (WatchScanStatus status) {
      _scanController.sinkAddSafe(status);
    });
  }

  Future<void> stopScan() async => await planifitUtils.stopScan();

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
