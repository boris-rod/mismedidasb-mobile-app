import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/fcm/fcm_message_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

final BehaviorSubject<bool> onPollNotificationLaunch = BehaviorSubject<bool>();

class AppBloC extends BaseBloC {
  final ILNM _ilnm;

  AppBloC(this._ilnm);

//  void resolveInitialSettings(SettingModel settingModel) async {
//    String locale = await _sharedPreferencesManager.getLanguageCode();
//    if (locale.isEmpty) {
//      if (["es", "en", "it"].contains(settingModel.languageCode))
//        locale = settingModel.languageCode;
//      else
//        locale = "es";
//    }
//    await _sharedPreferencesManager.setLanguageCode(locale);
//    languageCodeController.sinkAddSafe(settingModel);
//  }

  @override
  void dispose() {}

  void configureNotificationSystem() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  Future<void> _initLocalNotifications() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/logo');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    Injector.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      if (payload == LNM.pollNotificationId.toString()) {
        onPollNotificationLaunch.sinkAddSafe(true);
      }else{
        if(payload?.isNotEmpty == true)
          launch(payload);
      }
    });
    Injector.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _initFirebaseMessaging() async {
    Injector.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        _showNotification(message);
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        if (Platform.isIOS) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(message);
          FCMMessageModel model = FCMMessageModel.fromString(data);
          final payload = model?.externalUrl ?? "";
          if(payload?.isNotEmpty == true)
            launch(payload);
        }
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        if (Platform.isIOS) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(message);
          FCMMessageModel model = FCMMessageModel.fromString(data);
          final payload = model?.externalUrl ?? "";
          if(payload?.isNotEmpty == true)
            launch(payload);
        }
        return;
      },
    );
    Injector.firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
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
        summaryText: "",
        htmlFormatSummaryText: true);
    var platformChannelSpecificsAndroid =
        new AndroidNotificationDetails(LNM.fcmNoti.toString(), "", "",
            playSound: true,
            enableVibration: true,
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: bigTextStyleInformation);
    var platformChannelSpecificsIos = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: platformChannelSpecificsAndroid,
        iOS: platformChannelSpecificsIos);

    Injector.flutterLocalNotificationsPlugin.show(
      LNM.fcmNoti,
      title,
      message,
      platformChannelSpecifics,
      payload: model.externalUrl,
    );
  }
}
