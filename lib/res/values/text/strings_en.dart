import 'dart:ui';

import 'package:mismedidasb/res/values/text/strings_base.dart';


class StringsEn implements StringsBase {
  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "My Measures B";

  @override
  String get foodDishes => "My food dishes";

  @override
  String get myMeasureHealth => "My health measures";

  @override
  String get myMeasureValues => "My values measures";

  @override
  String get myMeasureWellness => "My wellness measures";

}
