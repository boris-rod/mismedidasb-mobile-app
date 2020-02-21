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

  UserModel(
      {this.id,
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
