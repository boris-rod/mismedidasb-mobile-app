
import 'package:mismedidasb/fcm/fcm_message_model.dart';

abstract class IFCMFeature {
  ///SetUps the fcm feature
  void setUp();
  Future<void> refreshToken();
  void deactivateToken();
  Stream<FCMMessageModel> onMessageActionBackground();
  Stream<FCMMessageModel> onMessageArrivesForeground();
  void clearBackgroundNotification();
  void clearForegroundNotification();

  void launchSampleNotification({FCMMessageModel message,bool foreground});
}