import 'dart:ui';

import 'package:mismedidasb/res/values/text/strings_base.dart';


class StringsEn implements StringsBase {
  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "Where To Have Lunch?";

  String get loginWithGoogle => "Login With Google";

  String get welcomeMessageBody =>
      "The easiest way of choosing where to have a nice meal with colleges";

  String get welcomeMessageTitle => "Welcome to \"$appName\"";

  String get places => "Places";

  String get settings => "Settings";

  String get choose => "Choose!";
}
