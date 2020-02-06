import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';

class MyMeasuresBApp extends StatefulWidget {
  final Widget initPage;

  const MyMeasuresBApp({Key key, this.initPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMeasuresBState();
}

class _MyMeasuresBState extends State<MyMeasuresBApp>{
  @override
  Widget build(BuildContext context) {
    final localizationDelegate = CustomLocalizationsDelegate();
    return MaterialApp(
      title: R.string.appName,
      debugShowCheckedModeBanner: Injector.instance.isInDebugMode(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        brightness: Brightness.light,
//        primarySwatch: Colors.deepOrange,
        fontFamily: "Fira",
        primaryColor: R.color.primary_color,
        primaryColorDark: R.color.primary_dark_color,
        accentColor: R.color.accent_color
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        brightness: Brightness.dark,
//        primarySwatch: Colors.deepOrange,
//        accentColor: Colors.deepOrange,
        fontFamily: "Fira",
          primaryColor: R.color.primary_color,
          primaryColorDark: R.color.primary_dark_color,
          accentColor: R.color.accent_color
      ),
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
//      initialRoute: AppRoutes.SPLASH,
//      routes: AppRoutes.routes(),
    );
  }
}