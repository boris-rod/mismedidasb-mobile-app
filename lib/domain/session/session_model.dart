
enum ACCOUNT_STATUS { PENDING, INACTIVE, ACTIVE}

class LoginModel {
  String email;
  String password;
  String timezone;
  int userTimeZoneOffset;

  LoginModel({this.email, this.password, this.timezone, this.userTimeZoneOffset});
}

class ValidateTokenModel {
  String token;

  ValidateTokenModel({this.token});
}
