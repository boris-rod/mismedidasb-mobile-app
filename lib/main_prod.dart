import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/splash/splash_page.dart';

import 'app.dart';
import 'di/injector.dart';

void main() {
  Injector.initProd();
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZonedGuarded(() {
    runApp(MyMeasuresBApp(
      initPage: SplashPage(),
      fcmFeature: Injector.instance.getDependency(),
      lnm: Injector.instance.getDependency(),
    ));
  }, (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    Crashlytics.instance.recordError(error, stackTrace);
  });
}