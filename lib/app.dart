import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/fcm/fcm_message_model.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

final BehaviorSubject<bool> onPollNotificationLaunch = BehaviorSubject<bool>();

class MyMeasuresBApp extends StatefulWidget {
  final Widget initPage;
  final IFCMFeature fcmFeature;
  final ILNM lnm;

  const MyMeasuresBApp({Key key, this.initPage, this.fcmFeature, this.lnm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMeasuresBState();
}

class _MyMeasuresBState extends StateWithBloC<MyMeasuresBApp, AppBloC>
    with WidgetsBindingObserver {
  final localizationDelegate = CustomLocalizationsDelegate();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // widget.fcmFeature.setUp();
    // widget.lnm.setup();
    _initLocalNotifications();
    _initFirebaseMessaging();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//  @override
//  void didChangePlatformBrightness() {
//    final Brightness brightness =
//        WidgetsBinding.instance.window.platformBrightness;
//    Injector.instance.darkTheme = brightness == Brightness.dark;
//  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<SettingModel>(
      stream: languageCodeResult,
      initialData: SettingModel(
          languageCode: "es", isDarkMode: false, showResumeBeforeSave: true),
      builder: (ctx, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child,
            );
          },
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
            RefreshLocalizations.delegate,
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

  _initLocalNotifications() async {
    var initializationSettingsAndroid = new AndroidInitializationSettings(
      '@drawable/logo',
    );

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    Injector.instance.localNotificationInstance.initialize(
        initializationSettings, onSelectNotification: (payload) async {
      if (payload == LNM.pollNotificationId.toString()) {
        onPollNotificationLaunch.sinkAddSafe(true);
      } else {
        if (payload?.isNotEmpty == true) launch(payload);
      }
    });

    Injector.instance.localNotificationInstance
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  _initFirebaseMessaging() async {
    _fireBaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print(message);
        _showNotification(message);
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> fcmMessage) {
        print("onResume FCM NOTI");
        print(fcmMessage);
        final Map<String, dynamic> data = Platform.isIOS
            ? fcmMessage
            : Map<String, dynamic>.from(fcmMessage["data"]);
        FCMMessageModel model = FCMMessageModel.fromString(data);
        final payload = model?.externalUrl ?? "";
        if (payload?.isNotEmpty == true) launch(payload);
        return;
      },
      onLaunch: (Map<String, dynamic> fcmMessage) {
        print("onLaunch FCM NOTI");
        print(fcmMessage);
        final Map<String, dynamic> data = Platform.isIOS
            ? fcmMessage
            : Map<String, dynamic>.from(fcmMessage["data"]);
        FCMMessageModel model = FCMMessageModel.fromString(data);
        final payload = model?.externalUrl ?? "";
        if (payload?.isNotEmpty == true) launch(payload);
        return;
      },
    );
    _fireBaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print(message);
    _showNotificationInBackground(message);
    return Future<void>.value();
  }

  static Future _showNotification(Map<String, dynamic> fcmMessage) async {
    final Map<String, dynamic> data = Platform.isIOS
        ? fcmMessage
        : Map<String, dynamic>.from(fcmMessage["data"]);
    FCMMessageModel model = FCMMessageModel.fromString(data);

    await _showCommonNotification(model);
  }

  static Future _showNotificationInBackground(
      Map<String, dynamic> fcmMessage) async {
    final Map<String, dynamic> data = Platform.isIOS
        ? fcmMessage
        : Map<String, dynamic>.from(fcmMessage["data"]);
    FCMMessageModel model = FCMMessageModel.fromString(data);

    await _showCommonNotification(model);
  }

  static Future _showCommonNotification(FCMMessageModel model) async {
    String title = model.title;
    String message = model.content;

    var bigTextStyleInformation = BigTextStyleInformation(message,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: "Planifive",
        htmlFormatSummaryText: true);
    var platformChannelSpecificsAndroid = new AndroidNotificationDetails(
        LNM.fcmNoti.toString(), "planifive_channel", "planifive_channel",
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecificsIos = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: platformChannelSpecificsAndroid,
        iOS: platformChannelSpecificsIos);

    await Injector.instance.localNotificationInstance.show(
      LNM.fcmNoti,
      title,
      message,
      platformChannelSpecifics,
      payload: model.externalUrl,
    );
  }
}
