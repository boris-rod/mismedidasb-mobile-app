import 'package:flutter/cupertino.dart';

const String EMAILREGEXP =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class TXValidator {
  static FormFieldValidator email(BuildContext context, bool available) {
    FormFieldValidator validator;

    if (available) {
      validator = (value) {
        if (value.toString().isEmpty) {
          return "Por Favor inserte texto";
        } else {
          return _validateEmail(value, context);
        }
      };
    } else {
      validator = (value) {
        return "R.string.validator_email_not_available";
      };
    }
    return validator;
  }

  static String _validateEmail(String value, BuildContext context) {
    Pattern pattern = EMAILREGEXP;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return "entre un email valido";
    else
      return null;
  }
  static FormFieldValidator password(BuildContext context) {
    FormFieldValidator validator = (value) {
      if (value.toString().isEmpty) {
        return "Por Favor inserte texto";
      } else if (value.toString().length < 8) {
        return "Por lo menos 8 caracteres";
      }else{
        return null;
      }
    };
    return validator;
  }

  static FormFieldValidator required(String value) {
    FormFieldValidator validator = (value) {
      return value.toString().trim().isEmpty ? 'Campo requerido' : null;
    };
    return validator;
  }
}
