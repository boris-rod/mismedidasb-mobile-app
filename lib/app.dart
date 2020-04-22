import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';

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
    widget.fcmFeature.setUp();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final localizationDelegate = CustomLocalizationsDelegate();
    return StreamBuilder(
      stream: bloc.languageResult,
      initialData: Locale("es"),
      builder: (ctx, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme:
                AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
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
            fallback: Locale("es"),
          ),
          locale: snapshot.data,
          home: widget.initPage,
          title: R.string.appName,
//      initialRoute: AppRoutes.SPLASH,
//      routes: AppRoutes.routes(),
        );
      },
    );
  }
}
