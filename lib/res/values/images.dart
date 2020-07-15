import 'package:mismedidasb/di/injector.dart';

class AppImage {
  String get plani => Injector.instance.planiId == 7 ? food_craving_home : (
      Injector.instance.planiId == 6 ? habits_home : (
          Injector.instance.planiId == 5 ? dishes_home : (
              Injector.instance.planiId == 4 ? wellness_home :(
                  Injector.instance.planiId == 3 ? values_home : (
                      Injector.instance.planiId == 2 ? health_home : logo
                  )
              )
          )
      )
  );
//  final logo_blue = 'lib/res/assets/img/logo_blue.png';
  final logo = 'lib/res/assets/img/logo.png';
  final logo_planifive = 'lib/res/assets/img/logo_planifive.png';
  final car = 'lib/res/assets/img/car_placeholder.png';
  final user = 'lib/res/assets/img/user_placeholder.png';
  final dishes_home = 'lib/res/assets/img/dishes_home.png';
  final habits_home = 'lib/res/assets/img/habits_home.png';
  final health_home = 'lib/res/assets/img/health_home.png';
  final wellness_home = 'lib/res/assets/img/wellness_home.png';
  final values_home = 'lib/res/assets/img/values_home.png';
  final food_craving_home = 'lib/res/assets/img/food_craving_home.png';
  final autocontrol = 'lib/res/assets/img/autocontrol.png';
  final medidas_bienestar = 'lib/res/assets/img/medidas_bienestar.png';
  final medidas_salud = 'lib/res/assets/img/medidas_salud.png';
  final medidas_valores = 'lib/res/assets/img/medidas_valores.png';
  final plan_comidas = 'lib/res/assets/img/plan_comidas.png';
  final habitos_saludables = 'lib/res/assets/img/habitos_saludables.png';
  final settings = 'lib/res/assets/img/settings.png';
  final values_home_blur = 'lib/res/assets/img/values_home_blur.png';
  final food_craving_home_blur = 'lib/res/assets/img/food_craving_home_blur.png';
  final wellness_home_blur = 'lib/res/assets/img/wellness_home_blur.png';
  final health_home_blur = 'lib/res/assets/img/health_home_blur.png';
  final habits_home_blur = 'lib/res/assets/img/habits_home_blur.png';
  final forward = 'lib/res/assets/img/forward.png';
  final backward = 'lib/res/assets/img/backward.png';
  final health_title = 'lib/res/assets/img/health_title.png';
  final values_title = 'lib/res/assets/img/values_title.png';
  final wellness_title = 'lib/res/assets/img/wellness_title.png';
  final craving_title = 'lib/res/assets/img/craving_title.png';
  final habits_title = 'lib/res/assets/img/habits_title.png';
  final icon_title = 'lib/res/assets/img/icon_title.png';
  final up_arrow_icon = 'lib/res/assets/img/up_arrow_icon.png';
  final down_arrow_icon = 'lib/res/assets/img/down_arrow_icon.png';
  final more_vertical_icon = 'lib/res/assets/img/more_vertical_icon.png';
  final divider_icon = 'lib/res/assets/img/divider_icon.png';
  final close_icon = 'lib/res/assets/img/close_icon.png';
  final calendar_icon = 'lib/res/assets/img/calendar_icon.png';
  final add_icon = 'lib/res/assets/img/add_icon.png';
  final under_limit_icon = 'lib/res/assets/img/under_limit_icon.png';
  final bar_scroll_icon = 'lib/res/assets/img/bar_scroll_icon.png';
  final divider_icon_yellow = 'lib/res/assets/img/divider_icon_yellow.jpeg';
}