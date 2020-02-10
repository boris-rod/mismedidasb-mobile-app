import 'dart:ui';

import 'package:mismedidasb/res/values/text/strings_base.dart';


class StringsEs implements StringsBase {
  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "Mis Medidas Bienestar";

  @override
  String get foodDishes => "Mis platos";

  @override
  String get myMeasureHealth => "Mis medidas de salud";

  @override
  String get myMeasureValues => "Mis medidas de valores";

  @override
  String get myMeasureWellness => "Mis medidas de bienestar";

  @override
  String get next => "Siguiente";

  @override
  String get previous => "Anterior";

  @override
  String get update => "Actualizar";
}
