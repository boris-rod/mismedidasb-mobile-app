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
  String get update => "Analizar";

  @override
  String get valuesConcept =>
      "Los valores son ideas o principios universales que dirigen nuestra conducta.";

  @override
  String get healthHabits => "10 Hábitos Saludables";

  @override
  String get checkNetworkConnection => "Por favor revise su conexión de red";

  @override
  String get failedOperation => "Falló la operación";

  @override
  String get forgotPassword => "Olvidó su contraseña?";

  @override
  String get login => "Entrar";

  @override
  String get password => "Contraseña";

  @override
  String get register => "Registrarse";

  @override
  String get remember => "Recordar";

  @override
  String get userName => "Nombre de ususario";

  @override
  String get email => "Correo";

  @override
  String get invalidEmail => "Correo inválido";

  @override
  String get minCharsLength => "Al menos 6 caractéres";

  @override
  String get requiredField => "Campo requerido";

  @override
  String get especialCharRequired => "Al menos 1 caractér especial";

  @override
  String get upperLetterCharRequired => "Al menos 1 caractér en mayúscula";

  @override
  String get passwordMatch => "La contraseña no coincide";

  @override
  String get recover => "Recuperar";

  @override
  String get code => "Código";

}
