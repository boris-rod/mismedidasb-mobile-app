import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/fcm/fcm_functions.dart';
import 'package:mismedidasb/fcm/fcm_message_model.dart';
import 'package:mismedidasb/fcm/fcm_parser.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/utils/logger.dart';
import 'package:rxdart/subjects.dart';

class FCMFeature extends IFCMFeature {
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  final NetworkHandler networkHandler;
  final Logger logger;
  final ILNM _ilnm;

  FCMFeature(this.networkHandler, this.logger, this._ilnm);

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
      logger.log('FCM TOKEN');
      logger.log(token);
      final deviceType = Platform.isAndroid ? 0 : (Platform.isIOS ? 1 : -1);
      await networkHandler.post(
          path: '/api/device',
          body: jsonEncode({'token': token, 'deviceType': deviceType}),
          doRefreshToken: true);
    } catch (ex) {
      logger.log('refresh Token Exception');
      logger.log(ex);
    }
  }

  @override
  void setUp() {
    _fireBaseMessaging.requestNotificationPermissions();
    _fireBaseMessaging.configure(
      onLaunch: _processMessageFromNotification,
      onResume: _processMessageFromNotification,
      onMessage: _processMessageForeground,
      /*onBackgroundMessage: myBackgroundMessageHandler*/
    );
  }

  Future<dynamic> _processMessageFromNotification(
      Map<String, dynamic> message) async {
    showRemoteNotification(message);
//    Fluttertoast.showToast(
//        msg: message.toString(), toastLength: Toast.LENGTH_SHORT);

//    print('FCM Message Background');
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
    showRemoteNotification(message);
//    Fluttertoast.showToast(
//        msg: message.toString(), toastLength: Toast.LENGTH_SHORT);

//    final fcmMessage = FCMJsonParser.parseJson(message);
//    if (fcmMessage.todoId != null) {
//      onMessageArrivesForegroundSubject.sink.add(fcmMessage);
//    }
  }

  void showRemoteNotification(Map<String, dynamic> message) async {
    final Map notification = message["notification"];
    if (notification != null) {
      String title = notification["title"];
      String content = notification["body"];
      final notiType =
          title?.trim()?.toLowerCase()?.contains("recompensa") == true
              ? NotificationType.REWARD
              : NotificationType.GENERAL;
      if (title?.isNotEmpty == true && content?.isNotEmpty == true) {
        _ilnm.showCommonNotification(
            channelId: LNM.fcmNoti,
            title: title,
            content: content,
            notificationType: notiType);
      }
    }
  }
}
