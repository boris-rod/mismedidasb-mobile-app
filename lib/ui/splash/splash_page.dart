import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/ui/login/login_page.dart';
import 'package:mismedidasb/ui/splash/splash_bloc.dart';
import 'dart:ui' as ui;

import 'package:mismedidasb/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends StateWithBloC<SplashPage, SplashBloC> {
  void initState() {
    super.initState();
    Utils.setStatusBarColor(R.color.primary_dark_color);

    Future.delayed(Duration(milliseconds: 100), (){
    String sysLanCode = ui.window.locale.languageCode;
    bloc.resolveInitialSettings(
        SettingModel(languageCode: sysLanCode, isDarkMode: false));
  });

    bloc.navigateResult.listen((result) {
      NavigationUtils.pushReplacement(
          context, (result ?? true) ? LoginPage() : HomePage());
    });
    bloc.shouldNavigateToLogin();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: R.color.primary_color,
        child: Center(
          child: Image.asset(
            R.image.logo_planifive,
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
