import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';

class HealthResult {
  static String getResult(HealthMeasureResultModel model) {
    String result = "";

    double dailyKal = 0.0;
    final IMC = model.weight / ((model.height / 100) * ((model.height / 100)));
    final TMB_PROV = 10 * model.weight + 6.25 * model.height - 5 * model.age;
    int dietSummary = 0;
    model.diet.forEach((value) {
      dietSummary += value;
    });

    if (model.sex == 1) {
      if (model.physicalExercise == 1) {
        dailyKal = (TMB_PROV + 5) * 1.2;
      } else if (model.physicalExercise == 2) {
        dailyKal = (TMB_PROV + 5) * 1.375;
      } else if (model.physicalExercise == 3) {
        dailyKal = (TMB_PROV + 5) * 1.55;
      } else if (model.physicalExercise == 4) {
        dailyKal = (TMB_PROV + 5) * 1.725;
      } else {
        dailyKal = (TMB_PROV + 5) * 1.9;
      }
    } else {
      if (model.physicalExercise == 1) {
        dailyKal = (TMB_PROV - 161) * 1.2;
      } else if (model.physicalExercise == 2) {
        dailyKal = (TMB_PROV - 161) * 1.375;
      } else if (model.physicalExercise == 3) {
        dailyKal = (TMB_PROV - 161) * 1.55;
      } else if (model.physicalExercise == 4) {
        dailyKal = (TMB_PROV - 161) * 1.725;
      } else {
        dailyKal = (TMB_PROV - 161) * 1.9;
      }
    }

    String IMCString = IMC.toStringAsFixed(2);
    if (IMC < 15) {
      model.result =
          "Usted presenta BAJO PESO EXTREMO ( $IMCString Kg/m2) ¡Consulte a un médico!";
    } else if (IMC >= 15 && IMC < 16) {
      model.result =
          "Usted presenta BAJO PESO GRAVE ( $IMCString Kg/m2) ¡Consulte a un médico!";
    }

    //Resultados bajo peso 16-17 con deporte y wc<7
    else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Hacer ejercicios parece ser un hábito, debería hacerlos con supervisión de un especialista. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Se sugiere consultar a un médico.";
    }

    //Resultados bajo peso 16-17 con deporte y wc>7
    else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary > 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary > 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary > 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, debería realizarlos con supervisión de un especialista. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary > 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas, debería realizarlos con supervisión de un especialista. Se sugiere consultar a un médico.";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary > 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Se sugiere consultar a un médico.";
    }

    //Resultados bajo peso 17-18 con deporte y wc<7
    else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary <= 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día y ajustada al gasto. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary <= 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día y ajustada al gasto. Hacer ejercicios parece ser un hábito, debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary <= 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día y ajustada al gasto. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas, debería realizarlos bajo supervisión de un especialista. Se sugiere consultar a un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary <= 7 &&
        model.physicalExercise == 5) {
      model.result =
          "( $IMCString Kg/m2): (BAJO PESO MODERADO): Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día y ajustada al gasto. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Se sugiere consultar a un médico.";
    }

    //Resultados bajo peso 17-18 con deporte y wc>7 //Instrucciones para Peso Normal
    else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary > 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary > 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2):  Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día y ajustada al gasto. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary > 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día y ajustada al gasto. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, debería realizar ejercicios centrados en incrementar masa muscular, siempre bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary > 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día y ajustada al gasto. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas, debería realizarlos bajo supervisión. Se sugiere consultar a un médico.";
    } else if (IMC >= 17 &&
        IMC < 18.5 &&
        dietSummary > 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted presenta BAJO PESO LIGERO ( $IMCString Kg/m2): Su ingesta de calorías debería estar por encima de $dailyKal Kcal/día y ajustada al gasto. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas, debería realizarlos bajo supervisión. Se sugiere consultar a un médico.";
    }

    //Instrucciones para Peso Normal deporte wc<4
    else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary <= 4 &&
        model.physicalExercise == 1) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Le recomendamos hacer ejercicios al menos 3 veces a la semana, para potenciar la salud y prevenir enfermedades.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary <= 4 &&
        model.physicalExercise == 2) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Se observa cierta regularidad en su práctica de ejercicio físico.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary <= 4 &&
        model.physicalExercise == 3) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Hacer ejercicios parece ser un hábito.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary <= 4 &&
        model.physicalExercise == 4) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary <= 4 &&
        model.physicalExercise == 5) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo).";
    }

    //Instrucciones para Peso Normal deporte wc entre 4 y 7
    else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso moderado de dietas en su historia vital. Le recomendamos hacer ejercicios al menos 3 veces a la semana, para potenciar la salud y prevenir enfermedades.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso moderado de dietas en su historia vital. Se observa cierta regularidad en su práctica de ejercicio físico.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso moderado de dietas en su historia vital. Hacer ejercicios parece ser un hábito.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso moderado de dietas en su historia vital. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso moderado de dietas en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo).";
    }

    //Instrucciones para Peso Normal deporte wc entre 7 y 12
    else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Le recomendamos hacer ejercicios al menos 3 veces a la semana, para potenciar la salud y prevenir enfermedades.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Se observa cierta regularidad en su práctica de ejercicio físico.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un medio para gestionar emociones y afrontar los problemas.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo).";
    }

    //Instrucciones para Peso Normal deporte wc > 12
    else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Le recomendamos hacer ejercicios al menos 3 veces a la semana, para potenciar la salud y prevenir enfermedades.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Se observa cierta regularidad en su práctica de ejercicio físico.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de severas fluctuaciones del peso, un uso crónico de la dietas o restricción y la práctica de ejercios como mecanismos para regular emociones y afrontar problemas.";
    } else if (IMC >= 18.5 &&
        IMC < 25 &&
        dietSummary > 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Su peso es NORMAL ( $IMCString Kg/m2): Acorde a su edad y actividad física debe ingerir al menos $dailyKal Kcal/día Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo).";
    }

    //Instrucciones para Sobrepeso deporte wc<4
    else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary <= 4 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Debería realizar ejercicio físico moderado. Ej. 4 veces por semana, 45 minutos por sesión.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary <= 4 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Hacer ejercicios con cierta regularidad, quizás deba incrementar su práctica a 4 veces por semana, 45 minutos por sesión.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary <= 4 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debería revisar sus hábitos alimentarios.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary <= 4 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Practicar ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Es probable que deba revisar su pauta ejercicios y/o de alimentación.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary <= 4 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Es probable que deba revisar su pauta ejercicios y/o de alimentación.";
    }

    //Instrucciones para Sobrepeso deporte wc entre 4 y 7
    else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Debería realizar ejercicio físico moderado. Ej. 4 veces por semana, 45 minutos por sesión.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Hace ejercicios con cierta regularidad, quizás deba incrementar su práctica a 4 veces por semana, 45 minutos por sesión.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debería revisar sus hábitos aliemntarios.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Practicar ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su de pauta ejercicios y/o de alimentación.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y/o de alimentación.";
    }

    //Instrucciones para Sobrepeso deporte wc entre 7 y 12
    else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hace ejercicios con cierta regularidad, quizás deba incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Practicar ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su pauta de ejercicios y conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para Sobrepeso deporte wc >12
    else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hace ejercicios con cierta regularidad, quizás deba incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Practicar ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su pauta de ejercicios y conducta alimentaria.";
    } else if (IMC >= 25 &&
        IMC < 30 &&
        dietSummary > 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Usted está en SOBREPESO ( $IMCString Kg/m2), que es un factor de riesgo para la salud, se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para Obesidad <40 deporte wc<4
    else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary <= 4 &&
        model.physicalExercise == 1) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary <= 4 &&
        model.physicalExercise == 2) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Hace ejercicios con cierta regularidad, debería incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary <= 4 &&
        model.physicalExercise == 3) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary <= 4 &&
        model.physicalExercise == 4) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Practicar ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su de pauta ejercicios y conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary <= 4 &&
        model.physicalExercise == 5) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para Obesidad <40 deporte wc de 5 a 7
    else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 2) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Hace ejercicios con cierta regularidad, debería incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 3) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 4) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Hacer ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su pauta de ejercicios y conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 4 &&
        dietSummary <= 7 &&
        model.physicalExercise == 5) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de dietas en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para Obesidad <35 deporte wc de 7 a 12
    else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hace ejercicios con cierta regularidad, debería incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su pauta de ejercicios y conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 7 &&
        dietSummary <= 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Muestra indicadores de fluctuaciones del peso y uso de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para Obesidad <40 deporte wc>12
    else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 12 &&
        model.physicalExercise == 1) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Debería realizar ejercicio físico moderado (Ej. 4 veces por semana, 45 minutos por sesión) y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 12 &&
        model.physicalExercise == 2) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hace ejercicios con cierta regularidad, debería incrementar su práctica a 4 veces por semana, 45 minutos por sesión y revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 12 &&
        model.physicalExercise == 3) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece ser un hábito, asegúrese de no realizar menos de 45 minutos por sesión. También debe revisar su conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 12 &&
        model.physicalExercise == 4) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Hacer ejercicios parece haberse convertido en un medio de afrontar dificultades y gestionar emociones. Debe revisar su pauta de ejercicios y conducta alimentaria.";
    } else if (IMC >= 30 &&
        IMC < 40 &&
        dietSummary > 12 &&
        model.physicalExercise == 5) {
      model.result =
          "Sus medidas indican OBESIDAD ( $IMCString Kg/m2), que es un problema de salud. Se recomienda ingerir cantidades inferiores a  $dailyKal Kcal/día. Se observan severas fluctuaciones del peso y un uso crónico de las dietas o restricción como mecanismo regulador en su historia vital. Podría estar haciendo ejercicios de forma compulsiva (a menos que sea un deportista activo). Debe revisar su pauta de ejercicios y conducta alimentaria.";
    }

    //Instrucciones para obesidad mórbida y extrema
    else if (IMC >= 40 && IMC < 50) {
      model.result =
          "IMC $IMCString Kg/m2 (OBESIDAD MÓRBIDA): ¡Consulte a un médico!";
    } else if (IMC >= 50) {
      model.result =
          "IMC $IMCString Kg/m2 (OBESIDAD MÓRBIDA): ¡Consulte a un médico!";
    }
    return result;
  }
}
