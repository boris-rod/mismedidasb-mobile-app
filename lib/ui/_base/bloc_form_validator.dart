import 'package:flutter/widgets.dart';
import 'package:mismedidasb/res/R.dart';

const String EMAILREGEXP =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const password_upper_case_letter = '[A-Z]';
const password_especial_char = '^[a-zA-Z0-9 ]*\$';

class FormValidatorBloC {
  FormFieldValidator email() {
    FormFieldValidator validator = (value) {
      if (value.toString().isEmpty) {
        return R.string.requiredField;
      } else {
        return _validateEmail(value);
      }
    };
    return validator;
  }

  String _validateEmail(String value) {
    Pattern pattern = EMAILREGEXP;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return R.string.invalidEmail;
    else
      return null;
  }

  FormFieldValidator password() {
    FormFieldValidator validator = (value) {
      if (value == null || value.toString().isEmpty) {
        return R.string.requiredField;
      } else if (value.toString().length < 6) {
        return R.string.minCharsLength;
      }
//      else if (RegExp(password_especial_char).hasMatch(value.toString())) {
//        return R.string.especialCharRequired;
//      } else if (!RegExp(password_upper_case_letter)
//          .hasMatch(value.toString())) {
//        return R.string.upperLetterCharRequired;
//      }
      else {
        return null;
      }
    };
    return validator;
  }

  FormFieldValidator passwordMatch(String match) {
    FormFieldValidator validator = (value) {
      if (value != match) {
        return R.string.passwordMatch;
      } else {
        return null;
      }
    };
    return validator;
  }

  FormFieldValidator required() {
    FormFieldValidator validator = (value) {
      return (value?.toString()?.trim()?.isEmpty == true)
          ? R.string.requiredField
          : null;
    };
    return validator;
  }
}
