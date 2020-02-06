class Endpoint {
  static String apiBaseUrl = "https://192.168.50.114:8083";

  ///Account
  static const String login = "/api/account/login";
  static const String logout = "/Account/LogOut";
  static const String recover_password = "/Account/ForgotPassword";
  static const String terms_cond = "/Users/PrivacyPolicyAgreement/public";

  ///User
  static const String profile = "/api/User/Get";
}
