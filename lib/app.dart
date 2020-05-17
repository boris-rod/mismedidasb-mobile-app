import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'dart:ui' as ui;

class MyMeasuresBApp extends StatefulWidget {
  final Widget initPage;
  final IFCMFeature fcmFeature;

  const MyMeasuresBApp(
      {Key key, @required this.initPage, @required this.fcmFeature})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMeasuresBState();
}

class _MyMeasuresBState extends StateWithBloC<MyMeasuresBApp, AppBloC> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: R.color.primary_dark_color
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    widget.fcmFeature.setUp();
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
            fontFamily: "Gotham",
            primaryColor: R.color.primary_color,
            primaryColorDark: R.color.primary_dark_color,
            accentColor: R.color.accent_color,
          ),
          darkTheme: ThemeData(
              appBarTheme:
                  AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
              brightness: Brightness.dark,
//        primarySwatch: Colors.deepOrange,
//        accentColor: Colors.deepOrange,
              fontFamily: "Gotham",
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
