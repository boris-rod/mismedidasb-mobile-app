import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/utils/logger.dart';

class FCMFeature extends IFCMFeature {
  final NetworkHandler networkHandler;
  final Logger logger;
  final firebaseMessaging = FirebaseMessaging();

  FCMFeature(this.networkHandler, this.logger);

  @override
  void deactivateToken() async {
    try {
      final token = await firebaseMessaging.getToken();
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
  Future<void> refreshToken() async {
    try {
      final token = await firebaseMessaging.getToken();
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
}
