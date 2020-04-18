import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_apns/apns.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/fcm/fcm_message_model.dart';
import 'package:mismedidasb/fcm/fcm_parser.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/utils/logger.dart';
import 'package:rxdart/subjects.dart';

class FCMFeature extends IFCMFeature {
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  final NetworkHandler networkHandler;
  final Logger logger;

  FCMFeature(this.networkHandler, this.logger);

  BehaviorSubject<
      // ignore: close_sinks
      FCMMessageModel> onMessageActionBackgroundSubject = BehaviorSubject();

  BehaviorSubject<
      // ignore: close_sinks
      FCMMessageModel> onMessageArrivesForegroundSubject = BehaviorSubject();

  @override
  void clearBackgroundNotification() {
    onMessageActionBackgroundSubject?.sink?.add(null);
  }

  @override
  void clearForegroundNotification() {
    onMessageArrivesForegroundSubject?.sink?.add(null);
  }

  @override
  void deactivateToken() async {
    try {
      final token = await _fireBaseMessaging.getToken();
      print(token);
      final deviceType = Platform.isAndroid ? 0 : (Platform.isIOS ? 1 : -1);
      await networkHandler.post(
          path: '/api/device',
          body: jsonEncode({'token': "", 'deviceType': deviceType}),
          doRefreshToken: false);
    } catch (ex) {
      logger.log('deactivate Token Exception');
      logger.log(ex);
    }
  }

  @override
  void launchSampleNotification({FCMMessageModel message, bool foreground}) {
    if (foreground)
      onMessageArrivesForegroundSubject?.sink?.add(message);
    else
      onMessageActionBackgroundSubject?.sink?.add(message);
  }

  @override
  Stream<FCMMessageModel> onMessageActionBackground() =>
      onMessageActionBackgroundSubject.stream;

  @override
  Stream<FCMMessageModel> onMessageArrivesForeground() =>
      onMessageArrivesForegroundSubject.stream;

  @override
  Future<void> refreshToken() async {
    try {
      final token = await _fireBaseMessaging.getToken();
      print('FCM TOKEN');
      print(token);
      final deviceType = Platform.isAndroid ? 0 : (Platform.isIOS ? 1 : -1);
      await networkHandler.post(
          path: '/api/device',
          body: jsonEncode({'token': token, 'deviceType': deviceType}),
          doRefreshToken: false);
    } catch (ex) {
      logger.log('refresh Token Exception');
      logger.log(ex);
    }
  }

  @override
  void setUp() {
//    final connector = createPushConnector();
//    connector.configure(onBackgroundMessage: (map) async {
//      print(map.toString());
//    });
    _fireBaseMessaging.configure(
      onLaunch: _processMessageFromNotification,
      onResume: _processMessageFromNotification,
      onMessage: _processMessageForeground,
    );

    _fireBaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _fireBaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings iosNotificationSettings) {});
  }

  Future<dynamic> _processMessageFromNotification(
      Map<String, dynamic> message) async {
    print('FCM Message Background');
//    Title = "Recordatorio",
//    Body = "Recuerde planificar lo que va a comer mañana."
//    print(message);
//    Fluttertoast.showToast(
//        msg: message.toString(), toastLength: Toast.LENGTH_SHORT);
//    final fcmMessage = FCMJsonParser.parseJson(message);
//    if (fcmMessage.todoId != null) {
//      onMessageActionBackgroundSubject.sink.add(fcmMessage);
//    }
  }

  Future<dynamic> _processMessageForeground(
      Map<String, dynamic> message) async {
    print(message);

//    final fcmMessage = FCMJsonParser.parseJson(message);
//    if (fcmMessage.todoId != null) {
//      onMessageArrivesForegroundSubject.sink.add(fcmMessage);
//    }
  }
}
