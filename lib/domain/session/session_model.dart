
enum ACCOUNT_STATUS { PENDING, INACTIVE, ACTIVE}

class LoginModel {
  String email;
  String password;
  String timezone;

  LoginModel({this.email, this.password, this.timezone});
}

class ValidateTokenModel {
  String token;

  ValidateTokenModel({this.token});
}
