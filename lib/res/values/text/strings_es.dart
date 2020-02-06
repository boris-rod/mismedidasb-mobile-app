import 'dart:ui';

import 'package:mismedidasb/res/values/text/strings_base.dart';


class StringsEs implements StringsBase {
  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "Mis Medidas B";

  @override
  String get foodDishes => "Mis platos";

  @override
  String get myMeasureHealth => "Mis medidas de salud";

  @override
  String get myMeasureValues => "Mis medidas de valores";

  @override
  String get myMeasureWellness => "Mis medidas de bienestar";
}
