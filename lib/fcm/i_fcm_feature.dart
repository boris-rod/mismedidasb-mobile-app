import 'package:mismedidasb/fcm/fcm_message_model.dart';

abstract class IFCMFeature {

  Future<void> refreshToken();

  void deactivateToken();
}
