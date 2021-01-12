class AppVersionModel {
  String version;
  bool isMandatory;

  AppVersionModel({this.version, this.isMandatory});
}

class ScoreModel {
  int id;
  int userId;
  int points;
  int coins;
  int eatCurrentStreak;
  int eatMaxStreak;
  int balancedEatCurrentStreak;
  int balancedEatMaxStreak;
  PersonalRankingModel personalRanking;
  UserModel user;

  ScoreModel(
      {this.id,
      this.userId,
      this.points,
      this.coins,
      this.eatCurrentStreak,
      this.eatMaxStreak,
      this.balancedEatCurrentStreak,
      this.balancedEatMaxStreak,
      this.personalRanking,
      this.user});
}

class PersonalRankingModel {
  int points;
  int rankingPosition;
  int percentageBehind;

  PersonalRankingModel(
      {this.points, this.rankingPosition, this.percentageBehind});
}

class UserModel {
  int id;
  String fullName;
  String email;
  String username;
  String phone;
  int statusId;
  String status;
  String avatar;
  String avatarMimeType;
  String role;
  int roleId;
  double dailyKCal;
  double imc;
  DateTime firstDateHealthResult;
  String language;
  bool termsAndConditionsAccepted;
  List<SubscriptionModel> subscriptions;

  UserModel(
      {this.id,
      this.dailyKCal,
      this.username,
      this.imc,
      this.firstDateHealthResult,
      this.fullName = "",
      this.email = "",
      this.phone,
      this.statusId,
      this.status,
      this.avatar = "",
      this.avatarMimeType = "",
      this.language,
      this.termsAndConditionsAccepted,
      this.role,
      this.roleId,
      this.subscriptions});
}

class SubscriptionModel {
  int id;
  int userId;
  int userSubscriptionId;
  int productId;
  String product;
  String name;
  String description;
  int valueCoins;
  bool isActive;
  DateTime validAt;

  SubscriptionModel(
      {this.id,
      this.userId,
      this.userSubscriptionId,
      this.productId,
      this.description,
      this.valueCoins,
      this.product,
      this.name = "",
      this.isActive,
      this.validAt});
}

class UserCredentialsModel {
  String email;
  String password;
  bool saveCredentials;

  UserCredentialsModel(
      {this.email = "", this.password = "", this.saveCredentials = false});
}

class PlanifiveProductsModel {
  int id;
  String idStr;
  int typeId;
  String type;
  String name;
  String nameEN;
  String nameIT;
  String description;
  String descriptionEN;
  String descriptionIT;
  int value;
  double price;
  DateTime createdAt;
  DateTime modifiedAt;

  PlanifiveProductsModel(
      {this.id,
      this.idStr,
      this.typeId,
      this.type,
      this.name,
      this.nameEN,
      this.nameIT,
      this.description,
      this.descriptionEN,
      this.descriptionIT,
      this.value,
      this.price,
      this.createdAt,
      this.modifiedAt});
}

class OrderModel {
  int id;
  String externalId;
  int userId;
  String userEmail;
  String userFullName;
  int productId;
  String productName;
  String productDescription;
  double amount;
  int statusId;
  String status;
  String statusInformation;
  int paymentMethodId;
  String paymentMethod;
  DateTime createdAt;
  DateTime modifiedAt;

  OrderModel(
      {this.id,
      this.externalId,
      this.userId,
      this.userEmail,
      this.userFullName,
      this.productId,
      this.productName,
      this.productDescription,
      this.amount,
      this.statusId,
      this.status,
      this.statusInformation,
      this.paymentMethodId,
      this.paymentMethod,
      this.createdAt,
      this.modifiedAt});
}

class CreditCardModel {
  String paymentMethodId;
  String country;
  String description;
  int expMonth;
  int expYear;
  String funding;
  String last4;

  CreditCardModel(
      {this.paymentMethodId,
      this.country,
      this.description,
      this.expMonth,
      this.expYear,
      this.funding,
      this.last4});
}

class UserUpdateModel {
  String username;
  String fullName;
  String phone;

  UserUpdateModel({this.username, this.fullName, this.phone});
}

class UsernameSuggestionModel {
  bool isValid;
  List<String> suggestions;

  UsernameSuggestionModel({this.isValid, this.suggestions});
}

class SoloQuestionStatsModel {
  int bestComplyEatStreak;
  int totalDaysPlannedSport;
  int totalDaysComplySportPlan;
  List<int> mostFrequentEmotions;
  int mostFrequentEmotionCount;

  SoloQuestionStatsModel(
      {this.bestComplyEatStreak,
      this.totalDaysPlannedSport,
      this.totalDaysComplySportPlan,
      this.mostFrequentEmotions,
      this.mostFrequentEmotionCount});
}
