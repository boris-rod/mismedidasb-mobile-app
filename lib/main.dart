import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mismedidasb/app.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/ui/habit/habit_page.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/ui/login/login_page.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_page.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_page.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_page.dart';
import 'package:mismedidasb/ui/splash/splash_page.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
  Injector.initProd();
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  FlutterError.onError = (FlutterErrorDetails details) {
//    if (isInDebugMode) {
//      // In development mode simply print to console.
//      FlutterError.dumpErrorToConsole(details);
//    } else {
//      // In production mode report to the application zone to report to
//      // Crashlytics.
//      Zone.current.handleUncaughtError(details.exception, details.stack);
//    }
//  };


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
