import 'dart:ui';

class AppColor {
  static bool isDarkTheme = false;

  Color get black_color => isDarkTheme  ? Color(0xFF000000) : Color(0xFFFFFFFF);
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

  final gray_darkest = Color(0xFF808080);
  final gray_dark = Color(0x5097A0AE);
  final gray = Color(0xFF97A0AE);
  final gray_light = Color(0xFFF6F7FB);

  Color get dialog_background => isDarkTheme ? Color(0xc8808080) : Color(0xc8F6F7FB);
  Color get blue_transparent => Color(0xc8448AFF);

  AppColor();
}
