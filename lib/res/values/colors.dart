import 'dart:ui';

class AppColor {
  final bool isDarkTheme ;

  final primary_color = Color(0xFF3F51B5);
  final primary_dark_color = Color(0xFF303F9F);
  final accent_color = Color(0xFF448AFF);

  final gray_darkest = Color(0xFF808080);
  final gray_dark = Color(0x5097A0AE);
  final gray = Color(0xFF97A0AE);
  final gray_light = Color(0xFFF6F7FB);

  Color get dialog_background => isDarkTheme ? Color(0xc8808080) : Color(0xc8F6F7FB);

  AppColor({this.isDarkTheme = false});
}
