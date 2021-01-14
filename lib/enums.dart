enum EnvironmentApp { Prod, Dev }

enum PopupActionKey {
  profile_settings,
  contact_us,
  about_us,
  faq,
  terms_cond,
  privacy_policies,
  references,
  logout,
  remove_account,
  remove_compound_food,
  show_kcal_percentage,
  daily_plan_instructions
}

enum PaymentProgress { GETTING_PRODUCTS, BUYING, VERIFYING, WAITING_ACTION, READY }

enum FoodFilterMode { tags, dish_healthy }
enum FoodHealthy {
  proteic,
  caloric,
  fruitVeg,
}
enum PROFILE_OPTION { CHANGE_PASSWORD, LOGOUT, HELP }
enum NotificationType { GENERAL, REMINDER, POLL, REWARD }
enum Reminder { NONE, DRINK_WATER, PLAN_FOOD, MAKE_EXERCISE }
enum SettingAction { logout, languageCodeChanged, removeAccount }
enum FoodsTypeMark { favorites, lackSelfControl, all }
