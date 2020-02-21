import 'dart:ui';

import 'package:mismedidasb/res/values/text/strings_base.dart';

class StringsEn implements StringsBase {
  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "My Measures Wellness";

  @override
  String get foodDishes => "My food dishes";

  @override
  String get myMeasureHealth => "My health measures";

  @override
  String get myMeasureValues => "My values measures";

  @override
  String get myMeasureWellness => "My wellness measures";

  @override
  String get next => "Next";

  @override
  String get previous => "Previous";

  @override
  String get update => "Analize";

  @override
  String get valuesConcept =>
      "Los valores son ideas o principios universales que dirigen nuestra conducta.";

  @override
  String get healthHabits => "10 Hábitos Saludables";

  @override
  String get checkNetworkConnection => "Please check your network connection.";

  @override
  String get failedOperation => "Operation failed.";

  @override
  String get forgotPassword => "Forgot password?";

  @override
  String get login => "Login";

  @override
  String get password => "Password";

  @override
  String get register => "Register";

  @override
  String get remember => "Remember";

  @override
  String get userName => "User Name";

  @override
  String get email => "Email";

  @override
  String get invalidEmail => "Invalid email.";

  @override
  String get minCharsLength => "At least 6 characters.";

  @override
  String get requiredField => "Required field.";

  @override
  String get especialCharRequired => "At least 1 especial character.";

  @override
  String get upperLetterCharRequired => "At least 1 upper case letter.";

  @override
  String get passwordMatch => "Password doesn't match.";

  @override
  String get recover => "Recover";

  @override
  String get code => "Code";

  @override
  String get activateAccount => "Activate account";

  @override
  String get reSendCode => "Send me the code again";

  @override
  String get checkEmail =>
      "Check your email in order to get activation code.";

  @override
  String get profile => "Profile";

  @override
  String get logout => "Logout";

  @override
  String get changePassword => "Change password";

  @override
  String get confirmPassword => "Confirm password";

  @override
  String get newPassword => "New password";

  @override
  String get oldPassword => "Old password";

  @override
  String get cancel => "Cancel";

  @override
  String get emailWillBeReceived => "You will receive an email with a new password.";

  @override
  String get ok => "Ok";

  @override
  String get logoutContent => "Are you sure you want to logout?";
}
