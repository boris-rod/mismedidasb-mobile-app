import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/enums.dart';

class Endpoint {
  static String apiBaseUrl = Injector.instance.env == EnvironmentApp.Dev
      ? "https://api-dev.metriri.com"
      : "https://api.metriri.com";

  ///General content
  static const String accept_terms_cond =
      "/api/general-content/accept-terms-conditions";
  static const String legacy_content_by_type = "/api/general-content/by-type";
  static const String contact_us_send_info = "/api/contact-us";
  static const String stripe_payment_action =
      "/api/payment/create-stripe-payment-intent";
  static const String planifive_products = "/api/product";
  static const String stripe_payment_methods =
      "/api/payment/stripe-payment-methods";

  ///Account
  static const String app_version = "/api/app";
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
  static const String save_settings = "/api/account/settings";
  static const String remove_account = "/api/account/remove-account";
  static const String username_validation = "/api/account/username-validation";

  static const String health_concept = "/api/concept"; //id

  static const String set_polls_result = "/api/poll/set-poll-result";
  static const String set_solo_polls_result = "/api/solo-question/user-answer";
  static const String get_poll = "/api/poll";

  static const String question = "/api/question"; //pollId
  static const String get_question = "/api/solo-question";

  static const String answer = "/api/answer"; //questionId

  static const String personal_data_current_data =
      "/api/personal-data/current-datas";

  static const String upload_avatar = "/api/account/upload-avatar";
  static const String invite = "/api/user-referral";
  static const String scores = "/api/user-statistics/by-user-id";
  static const String solo_question_stats = "/api/solo-question";

  static const String dish = "/api/dish";
  static const String dish_favorites = "/api/dish/favorites";
  static const String dish_lack_self_control =
      "/api/dish/lack-self-control-dishes";
  static const String dish_tags = "/api/tag";

  static const String dish_compound = "/api/compound-dish";
  static const String delete_compound = "/api/compound-dish/delete";

  static const String eat_by_date_range = "/api/eat/by-date";
  static const String save_daily_food_plan = "/api/eat/bulk-eats";

//  static const String save_daily_activity = "/api/eat/add-or-update";
  static const String plan_daily_parameters = "/api/user/eat-health-parameters";
  static const String plan_daily_info = "api/eat/is-balanced-plan";
  static const String add_food_to_favorites = "/api/dish/favorite/create";
  static const String remove_food_from_favorites = "/api/dish/favorite/delete";
  static const String add_lack_self_control =
      "/api/dish/lack-self-control/create";
  static const String remove_lack_self_control =
      "/api/dish/lack-self-control/delete";

  static const String planiIntroVideo = "https://youtu.be/flhvp9Zp-ak";
  static const String foodPlanVideo = "https://youtu.be/O5BrcOFpP5g";
  static const String copyPlanVideo = "https://youtu.be/csyl8IhRvjo";
  static const String foodPortionsVideo = "https://youtu.be/Qpq9r-HelYU";
  static const String profileSettingsVideo = "https://youtu.be/A32xyoLiJjY";
  static const String whoIsPlaniVideo = "https://youtu.be/8q2bI-GY8s4";
  static const String planiHabitsVideo = "https://youtu.be/Fk7Ol4b-V6M";
  static const String planiCravingVideo = "https://youtu.be/KrY3ZW8G95w";
}
