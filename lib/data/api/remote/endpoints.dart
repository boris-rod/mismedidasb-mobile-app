class Endpoint {
  static String apiBaseUrl = "http://ec2-52-15-173-73.us-east-2.compute.amazonaws.com";

  ///Account
  static const String register = "/api/account/register";
  static const String login = "/api/account/login";
  static const String logout = "/api/account/logout";
  static const String refresh_token = "/api/account/refresh-token";
  static const String validate_token = "/api/account/validate-token";
  static const String change_password = "/api/account/change-password";
  static const String recover_password = "/api/account/forgot-password";
  static const String activation_account = "/api/account/activate-account";
  static const String resend_code = "/api/account/resend-code";
  static const String profile = "/api/account/profile";

  static const String health_concept = "/api/concept"; //id

  static const String set_polls_result = "/api/poll/set-poll-result";
  static const String get_poll = "/api/poll";

  static const String question = "/api/question"; //pollId

  static const String answer = "/api/answer"; //questionId


  static const String personal_data_current_data =
      "/api/personal-data/current-datas";

  static const String update_profile = "/api/account/update-profile";
  static const String upload_avatar = "/api/account/upload-avatar";


  static const String dish = "/api/dish";
  static const String dish_tags = "/api/tag";

  static const String eat_by_date_range = "/api/eat/by-date";
}
