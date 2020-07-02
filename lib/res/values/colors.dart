import 'dart:ui';

import 'package:mismedidasb/di/injector.dart';

class AppColor {

  Color get black_color => Injector.instance.darkTheme  ? Color(0xFFFFFFFF) : Color(0xFF000000);
  Color get white_color => !Injector.instance.darkTheme  ? Color(0xFFFFFFFF) : Color(0xFF000000);
  final primary_color = Color(0xFF3F51B5);
  final primary_dark_color = Color(0xFF303F9F);
  final accent_color = Color(0xFF448AFF);
  final home_color = Color(0xFFa3bbff);
  final values_color = Color(0xFF8e2900);
  final wellness_color = Color(0xFF31a501);
  final health_color = Color(0xFFff3b3d);
  final craving_color = Color(0xFF8f004b);
  final craving_number_color = Color(0xFFed799c);
  final habits_color = Color(0xFF2046d6);
  final habits_number_color = Color(0xFFf8a41f);

  final gray_darkest = Injector.instance.darkTheme ? Color(0xFFF6F7FB) : Color(0xFF808080);
  final gray_dark = Injector.instance.darkTheme ? Color(0xFF97A0AE) : Color(0x5097A0AE);
  final gray = Injector.instance.darkTheme ? Color(0x5097A0AE) : Color(0xFF97A0AE);
  final gray_light = Injector.instance.darkTheme ? Color(0xFF808080) : Color(0xFFF6F7FB);
  final food_action_bar = Color(0xFF2383D5);
  final food_background = Color(0xFF0000FE);
  final food_nutri_info = Color(0xFFFEB300);
  final food_yellow = Color(0xFFFFFF00);
  final food_green = Color(0xFF30FE00);
  final food_red = Color(0xFFFF0000);
  final food_blue_dark = Color(0xFF282FBB);
  final food_blue_medium = Color(0xFF353FFA);
  final food_blue_violet = Color(0xFF5D62FA);

  Color get dialog_background =>
      Injector.instance.darkTheme ? Color(0xc8808080) : Color(0xc8F6F7FB);
  Color get blue_transparent => Color(0xc8448AFF);

  AppColor();
}
