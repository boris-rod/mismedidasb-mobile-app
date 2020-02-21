import 'package:flutter/material.dart';
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
  Injector.initProd();
  runApp(
    MyMeasuresBApp(
      initPage: SplashPage(),
    ),
  );
}
