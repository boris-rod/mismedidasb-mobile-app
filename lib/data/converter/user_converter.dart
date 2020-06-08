import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserConverter implements IUserConverter {
  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json[RemoteConstants.id],
        fullName: json[RemoteConstants.full_name],
        username: json[RemoteConstants.user_name],
        email: json[RemoteConstants.email],
        phone: json[RemoteConstants.phone],
        statusId: json[RemoteConstants.status_id],
        status: json[RemoteConstants.status],
        avatar: json[RemoteConstants.avatar],
        avatarMimeType: json[RemoteConstants.avatar_mime_type],
        role: json[RemoteConstants.role],
        roleId: json[RemoteConstants.role_id],
        dailyKCal: json[RemoteConstants.daily_kcal],
        language: json[RemoteConstants.language],
        termsAndConditionsAccepted: json[RemoteConstants.terms_cond],
        firstDateHealthResult:
            json[RemoteConstants.first_date_health_result] != null
                ? DateTime.parse(json[RemoteConstants.first_date_health_result])
                    .toLocal()
                : DateTime.now(),
        imc: json[RemoteConstants.imc],
        subscriptions: json.containsKey("subscriptions")
            ? (json["subscriptions"] as List<dynamic>)
                .map((e) => fromJsonSubscription(e))
                .toList()
            : []);
  }

  @override
  Map<String, dynamic> toJson(UserModel userModel) {
    return {
      RemoteConstants.full_name: userModel.fullName,
      RemoteConstants.user_name: userModel.username,
      RemoteConstants.phone: userModel.phone,
    };
  }

  @override
  Subscription fromJsonSubscription(Map<String, dynamic> json) {
    final Subscription model = Subscription(
        id: json["id"],
        userId: json["userId"],
        userSubscriptionId: json["userSubscriptionId"],
        productId: json["productId"],
        product: json["product"],
        name: json["name"],
        isActive: json["isActive"],
        validAt: DateTime.parse(json["validAt"]).toLocal());
    return model;
  }
}
