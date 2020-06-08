import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserConverter {
  UserModel fromJson(Map<String, dynamic> json);

  Subscription fromJsonSubscription(Map<String, dynamic> json);

  Map<String, dynamic> toJson(UserModel userModel);

}
