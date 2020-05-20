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
      this.roleId});
}

class UserCredentialsModel {
  String email;
  String password;
  bool saveCredentials;

  UserCredentialsModel(
      {this.email = "", this.password = "", this.saveCredentials = false});
}
