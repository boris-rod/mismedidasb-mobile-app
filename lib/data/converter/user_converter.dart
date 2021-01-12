import 'dart:io';

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
                ? DateTime.parse(
                    json[RemoteConstants.first_date_health_result],
                  ).toLocal()
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
  SubscriptionModel fromJsonSubscription(Map<String, dynamic> json) {
    final SubscriptionModel model = SubscriptionModel(
        id: json["id"],
        userId: json["userId"],
        userSubscriptionId: json["userSubscriptionId"],
        productId: json["productId"],
        product: json["product"],
        name: json["name"],
        valueCoins: json["valueCoins"],
        isActive: json["isActive"],
        validAt: DateTime.parse(json["validAt"]).toLocal());
    return model;
  }

  @override
  PersonalRankingModel fromJsonPersonalRanking(Map<String, dynamic> json) {
    final PersonalRankingModel model = PersonalRankingModel(
        points: json["points"],
        rankingPosition: json["rankingPosition"],
        percentageBehind: json["percentageBehind"]);
    return model;
  }

  @override
  ScoreModel fromJsonScore(Map<String, dynamic> json) {
    final ScoreModel model = ScoreModel(
        id: json["id"],
        userId: json["userId"],
        points: json["points"],
        coins: json["coins"],
        eatCurrentStreak: json["eatCurrentStreak"],
        eatMaxStreak: json["eatMaxStreak"],
        balancedEatCurrentStreak: json["balancedEatCurrentStreak"],
        balancedEatMaxStreak: json["balancedEatMaxStreak"],
        personalRanking: fromJsonPersonalRanking(json["personalRanking"]),
        user: fromJson(json["user"]));
    return model;
  }

  @override
  UsernameSuggestionModel fromJsonUsernameSuggestionModel(
      Map<String, dynamic> json) {
    UsernameSuggestionModel model = UsernameSuggestionModel(
        isValid: json["isValid"], suggestions: List.from(json["suggestions"]));
    return model;
  }

  @override
  SoloQuestionStatsModel fromJsonSoloQuestionStats(Map<String, dynamic> json) {
    SoloQuestionStatsModel model = SoloQuestionStatsModel(
        bestComplyEatStreak: json["bestComplyEatStreak"],
        totalDaysPlannedSport: json["totalDaysPlannedSport"],
        totalDaysComplySportPlan: json["totalDaysComplySportPlan"],
        mostFrequentEmotions: List.from(json["mostFrequentEmotions"]),
        mostFrequentEmotionCount: json["mostFrequentEmotionCount"]);
    return model;
  }

  @override
  AppVersionModel fromJsonAppVersion(Map<String, dynamic> json) {
    AppVersionModel model = AppVersionModel(
        version: (Platform.isIOS && json.containsKey("versionIOS"))
            ? json["versionIOS"]
            : json["version"],
        isMandatory: (Platform.isIOS && json.containsKey("isMandatoryIOS"))
            ? json["isMandatoryIOS"]
            : json["isMandatory"]);
    return model;
  }

  @override
  PlanifiveProductsModel fromJsonPlanifiveProductsModel(
      Map<String, dynamic> json) {
    PlanifiveProductsModel model = PlanifiveProductsModel(
        id: json["id"],
        typeId: json["typeId"],
        type: json["type"],
        name: json["name"],
        nameEN: json["nameEN"],
        nameIT: json["nameIT"],
        description: json["description"],
        descriptionEN: json["descriptionEN"],
        descriptionIT: json["descriptionIT"],
        value: json["value"],
        price: json["price"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        modifiedAt: DateTime.parse(json["modifiedAt"]).toLocal());
    return model;
  }

  @override
  CreditCardModel fromJsonCreditCardModel(Map<String, dynamic> json) {
    CreditCardModel model = CreditCardModel(
        paymentMethodId: json["paymentMethodId"],
        country: json["country"],
        description: json["description"],
        expMonth: json["expMonth"],
        expYear: json["expYear"],
        funding: json["funding"],
        last4: json["last4"]);
    return model;
  }

  @override
  OrderModel fromJsonOrder(Map<String, dynamic> json) {
    OrderModel model = OrderModel(
      id: json["id"],
        externalId: json["externalId"],
        userId: json["userId"],
        userEmail: json["userEmail"],
        userFullName: json["userFullName"],
        productId: json["productId"],
        productName: json["productName"],
        productDescription: json["productDescription"],
        amount: json["amount"],
        statusId: json["statusId"],
        status: json["status"],
        statusInformation: json["statusInformation"],
        paymentMethodId: json["paymentMethodId"],
        paymentMethod: json["paymentMethod"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(
          json["createdAt"],
        ).toLocal()
            : DateTime.now(),
      modifiedAt: json["modifiedAt"] != null
          ? DateTime.parse(
        json["modifiedAt"],
      ).toLocal()
          : DateTime.now(),
    );
    return model;
  }
}
