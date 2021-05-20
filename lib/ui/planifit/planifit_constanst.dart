import 'dart:async';

import 'package:flutter/services.dart';

final platform = const MethodChannel('watch.metriri.com/actions_from_flutter');
final eventsStream =
    const EventChannel('watch.metriri.com/actions_from_native');
final eventChannelSinkKey = "EVENT_CHANNEL_SINK_TYPE_KEY";

Stream planifitEventsStream;

final START_SCAN = "start_scan";
final STOP_SCAN = "stop_scan";
final CONNECT = "connect";
final DISCONNECT = "disconnect";
final IS_SUPPORT_BLE = "is_support_ble";
final IS_BLE_ENABLED = "is_ble_enabled";

final LE_SCAN_CALLBACK = "LeScanCallback";
final BLOOD_PRESSURE_CALLBACK = "mOnBloodPressureListener";
final RATE_CALLBACK = "mOnRateListener";
final STEP_CHANGE_CALLBACK = "mOnStepChangeListener";

Future<bool> supportBLE() async {
  try {
    final result = await platform.invokeMethod(IS_SUPPORT_BLE);
    return result;
  } on PlatformException catch (e) {
    print("Failed to start scan: '${e.message}'.");
    return false;
  }
}

Future<bool> iSBLEEnabled() async {
  try {
    final result = await platform.invokeMethod(IS_BLE_ENABLED);
    return result;
  } on PlatformException catch (e) {
    print("Failed to start scan: '${e.message}'.");
    return false;
  }
}


