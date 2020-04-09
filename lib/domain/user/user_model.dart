class UserModel {
  int id;
  String fullName;
  String email;
  String phone;
  int statusId;
  String status;
  String avatar;
  String avatarMimeType;
  String role;
  int roleId;
  double dailyKCal;
  double imc;

  UserModel(
      {this.id,
      this.dailyKCal = 0,
      this.imc = 0,
      this.fullName = "",
      this.email = "",
      this.phone,
      this.statusId,
      this.status,
      this.avatar = "",
      this.avatarMimeType = "",
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
