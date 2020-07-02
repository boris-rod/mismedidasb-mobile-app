import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/colors.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'dart:ui' as ui;

import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/poll_notification/poll_notification_page.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';

class MyMeasuresBApp extends StatefulWidget {
  final Widget initPage;
  final IFCMFeature fcmFeature;
  final ILNM lnm;

  const MyMeasuresBApp(
      {Key key, @required this.initPage, @required this.fcmFeature, this.lnm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMeasuresBState();
}

class _MyMeasuresBState extends StateWithBloC<MyMeasuresBApp, AppBloC> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    widget.fcmFeature.setUp();
    widget.lnm.setup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
//    final Brightness brightness =
//        WidgetsBinding.instance.window.platformBrightness;
//    Injector.instance.darkTheme = brightness == Brightness.dark;
  }


  @override
  Widget buildWidget(BuildContext context) {
    final localizationDelegate = CustomLocalizationsDelegate();
    return StreamBuilder<SettingModel>(
      stream: languageCodeResult,
      initialData: SettingModel(
          languageCode: "es", isDarkMode: false, showResumeBeforeSave: true),
      builder: (ctx, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme:
                AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
            brightness: Brightness.light,
//        primarySwatch: Colors.deepOrange,
            fontFamily: "Raleway",
            primaryColor: R.color.primary_color,
            primaryColorDark: R.color.primary_dark_color,
            accentColor: R.color.accent_color,
          ),
          darkTheme: ThemeData(
//              popupMenuTheme: PopupMenuThemeData(color: Colors.white),
//              dialogBackgroundColor: Colors.white,
//              appBarTheme:
//                  AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
              brightness: Brightness.light,
//        primarySwatch: Colors.deepOrange,
//        accentColor: Colors.deepOrange,
              fontFamily: "Raleway",
              primaryColor: R.color.primary_color,
              primaryColorDark: R.color.primary_dark_color,
              accentColor: R.color.accent_color),
          localizationsDelegates: [
            localizationDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          localeResolutionCallback: localizationDelegate.resolution(
            fallback: ui.Locale("es"),
          ),
          locale: ui.Locale(snapshot.data.languageCode),
          home: widget.initPage,
          title: R.string.appName,
//      initialRoute: AppRoutes.SPLASH,
//      routes: AppRoutes.routes(),
        );
      },
    );
  }
}
