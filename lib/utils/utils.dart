import 'dart:ui';

import 'package:flutter/services.dart';

class Utils {
  static setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color));
  }
}
