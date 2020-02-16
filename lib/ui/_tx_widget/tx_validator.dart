import 'package:flutter/cupertino.dart';
import 'package:mismedidasb/res/R.dart';

//const String EMAILREGEXP =
//    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const password_upper_case_letter = '[A-Z]';
const password_especial_char = '^[a-zA-Z0-9 ]*\$';

class TXValidator {
//  static FormFieldValidator email() {
//    FormFieldValidator validator = (value) {
//      if (value.toString().isEmpty) {
//        return R.string.requiredField;
//      } else {
//        return _validateEmail(value);
//      }
//    };
//    return validator;
//  }

//  static FormFieldValidator dateValidator(DateTime dateTime) {
//    FormFieldValidator validator;
//    validator = (value) {
//      Duration duration = DateTime.now().difference(dateTime);
//      if (duration.inMinutes < 5) {
//        return R.string.invalid_time;
//      } else {
//        return null;
//      }
//    };
//    return validator;
//  }

//  static String _validateEmail(String value) {
//    Pattern pattern = EMAILREGEXP;
//    RegExp regex = RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return R.string.invalidEmail;
//    else
//      return null;
//  }

  static FormFieldValidator password() {
    FormFieldValidator validator = (value) {
      if (value == null || value.toString().isEmpty) {
        return R.string.requiredField;
      } else if (value.toString().length < 6) {
        return R.string.minCharsLength;
      } else if (RegExp(password_especial_char).hasMatch(value.toString())) {
        return R.string.especialCharRequired;
      } else if (!RegExp(password_upper_case_letter)
          .hasMatch(value.toString())) {
        return R.string.upperLetterCharRequired;
      } else {
        return null;
      }
    };
    return validator;
  }

  static FormFieldValidator passwordMatch(String match) {
    FormFieldValidator validator = (value) {
      if (value != match) {
        return R.string.passwordMatch;
      } else {
        return null;
      }
    };
    return validator;
  }

  static FormFieldValidator required() {
    FormFieldValidator validator = (value) {
      return (value?.toString()?.trim()?.isEmpty == true)
          ? R.string.requiredField
          : null;
    };
    return validator;
  }
}
