import 'dart:async';

import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/planifit/planifit_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class PlanifitScanBloC extends BaseBloC {
  final PlanifitUtils planifitUtils;

  PlanifitScanBloC(this.planifitUtils);

  @override
  void dispose() {
    _scanController.close();
    _devicesDataController.close();
    _eventsSubscription.cancel();
  }

  BehaviorSubject<WatchScanStatus> _scanController = new BehaviorSubject();

  Stream<WatchScanStatus> get scanResult => _scanController.stream;

  BehaviorSubject<Map<String, BleDevice>> _devicesDataController =
      new BehaviorSubject();

  Stream<Map<String, BleDevice>> get devicesDataResult =>
      _devicesDataController.stream;

  StreamSubscription _eventsSubscription;

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
}
