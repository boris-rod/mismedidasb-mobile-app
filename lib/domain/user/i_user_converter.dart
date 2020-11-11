import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserConverter {
  UserModel fromJson(Map<String, dynamic> json);

  Subscription fromJsonSubscription(Map<String, dynamic> json);

  PlanifiveProductsModel fromJsonPlanifiveProductsModel(Map<String, dynamic> json);

  CreditCardModel fromJsonCreditCardModel(Map<String, dynamic> json);

  Map<String, dynamic> toJson(UserModel userModel);

  ScoreModel fromJsonScore(Map<String, dynamic> json);

  AppVersionModel fromJsonAppVersion(Map<String, dynamic> json);

  PersonalRankingModel fromJsonPersonalRanking(Map<String, dynamic> json);

  UsernameSuggestionModel fromJsonUsernameSuggestionModel(
      Map<String, dynamic> json);

  SoloQuestionStatsModel fromJsonSoloQuestionStats(Map<String, dynamic> json);
}
