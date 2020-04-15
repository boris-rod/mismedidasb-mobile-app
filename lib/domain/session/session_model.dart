
enum ACCOUNT_STATUS { PENDING, INACTIVE, ACTIVE}

class LoginModel {
  String email;
  String password;

  LoginModel({this.email, this.password});
}

class ValidateTokenModel {
  String token;

  ValidateTokenModel({this.token});
}
