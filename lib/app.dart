import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';

class MyMeasuresBApp extends StatefulWidget {
  final Widget initPage;
  final IFCMFeature fcmFeature;

  const MyMeasuresBApp(
      {Key key, @required this.initPage, @required this.fcmFeature})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMeasuresBState();
}

class _MyMeasuresBState extends State<MyMeasuresBApp> {
  @override
  void initState() {
    super.initState();
    widget.fcmFeature.setUp();
  }

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = CustomLocalizationsDelegate();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        brightness: Brightness.light,
//        primarySwatch: Colors.deepOrange,
        fontFamily: "Fira",
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
          fontFamily: "Fira",
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
        fallback: Locale("en"),
      ),
      home: widget.initPage,
      title: R.string.appName,
//      initialRoute: AppRoutes.SPLASH,
//      routes: AppRoutes.routes(),
    );
  }
}
