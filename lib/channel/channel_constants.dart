import 'package:flutter/services.dart';

class ChannelConstants {
  static const platform = const MethodChannel('mismedidas.metriri.com/test');


  Future<Null> _showNativeView() async {
    await platform.invokeMethod('showNativeView');
  }
}
