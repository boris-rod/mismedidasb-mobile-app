class RegisterModel {
  String email;
  String fullName;
  String password;
  String confirmationPassword;

  RegisterModel(
      {this.email, this.fullName, this.password, this.confirmationPassword});
}


class ActivationAccountModel{
  int code;
  String email;

  ActivationAccountModel({this.code, this.email});
}

class ChangePasswordModel{
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswordModel({this.oldPassword, this.newPassword, this.confirmPassword});
}
