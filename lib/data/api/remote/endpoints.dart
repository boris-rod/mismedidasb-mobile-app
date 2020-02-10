class Endpoint {
  static String apiBaseUrl = "https://192.168.50.114:8083";

  ///Account
  static const String register = "/api/account/register";
  static const String login = "/api/account/login";
  static const String logout = "/api/account/logout";
  static const String refresh_token = "/api/account/refresh-token";
  static const String validate_token = "/api/account/validate-token";
  static const String change_password = "/Account/change-password";
  static const String recover_password = "/Account/forgot-password";
  static const String activation_account = "/api/account/activation-account";
  static const String resend_code = "/api/account/resend-code";

  static const String health_concept = "/api/concept"; //id

  static const String health_concept_polls = "/polls";

  static const String question = "/api/question"; //pollId

  static const String answer = "/api/answer"; //questionId


  static const String personal_data_current_data =
      "/api/personal-data/current-datas";

  static const String update_account = "/api/account/update-profile";
  static const String upload_avatar = "/api/account/upload-avatar";
  static const String get_profile = "/api/account/user-profile";

  ///User
  static const String profile = "/api/User/Get";
}
