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
  List<Subscription> subscriptions;

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

class Subscription {
  int id;
  int userId;
  int userSubscriptionId;
  int productId;
  String product;
  String name;
  bool isActive;
  DateTime validAt;

  Subscription(
      {this.id,
      this.userId,
      this.userSubscriptionId,
      this.productId,
      this.product,
      this.name,
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
