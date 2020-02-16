import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class ValueResultModel {
  List<MeasureValueModel> values;
  List<String> results;

  ValueResultModel({this.values, this.results});
}

class MeasureValueModel {
  QuestionModel question;
  List<AnswerModel> answers;
  AnswerModel selectedAnswer;

  MeasureValueModel({this.question, this.selectedAnswer, this.answers});
}

class ValueResult {
  static List<String> getResult(ValueResultModel model) {
    List<String> list = [];

    int value1 = model.values[0].selectedAnswer.weight;
    int value2 = model.values[1].selectedAnswer.weight;
    int value3 = model.values[2].selectedAnswer.weight;
    int value4 = model.values[3].selectedAnswer.weight;
    int value5 = model.values[4].selectedAnswer.weight;
    int value6 = model.values[5].selectedAnswer.weight;
    int value7 = model.values[6].selectedAnswer.weight;
    int value8 = model.values[7].selectedAnswer.weight;
    int value9 = model.values[8].selectedAnswer.weight;
    int value10 = model.values[9].selectedAnswer.weight;

    String resp1 = value1 >= 6
        ? "1. Elevada tendencia a mostrar comportamientos socialmente esperados."
        : (value1 > 4 && value1 < 6
            ? "1. Tendencia moderada a mostrar comportamientos socialmente esperados."
            : "1. Escasa tendencia a mostrar comportamientos socialmente esperados.");
    String resp2 = value1 >= 6
        ? "2. Profunda aceptación de las costumbres y tradiciones de su cultura."
        : (value2 > 4 && value2 < 6
            ? "2. Respeta las costumbres y tradiciones de su cultura."
            : "2. Dificultades para aceptar las costumbres y tradiciones de su cultura.");
    String resp3 = value3 >= 6
        ? "3. Alta lealtad, honestidad, y compasión hacia personas cercanas."
        : "3. Lealtad, honestidad y compasión no son sus valores primarios.";
    String resp4 = value4 >= 6
        ? "4. Gran compromiso con la protección de la naturaleza y la vida."
        : (value4 > 4 && value4 < 6
            ? "4. Considera relevante la protección naturaleza y la vida."
            : "4. Poco compromiso con la protección de la naturaleza y la vida.");
    String resp5 = value5 >= 6
        ? "5. Elevada independencia de pensamiento y acción."
        : "5. La independencia de pensamiento y acción no su punto fuerte.";
    String resp6 = value6 >= 6
        ? "6. Muy orientado hacia la búsqueda de nuevos retos y experiencias excitantes."
        : (value6 > 4 && value6 < 6
            ? "6. Le gustan los retos y las vivencias novedosas."
            : "6. La búsqueda de retos y experiencias nuevas no es su punto fuerte.");
    String resp7 = value7 >= 6
        ? "7. Elevada búsqueda de placer y gratificación sensorial."
        : (value7 > 4 && value7 < 6
            ? "7. Otorga importancia al placer y la gratificación sensorial."
            : "7. Otorga poca importancia al placer y la gratificación sensorial.");
    String resp8 = value8 == 7
        ? "8. El sacrificio y el trabajo duro son valores primarios."
        : (value8 > 5 && value8 < 7
            ? "8. Otorga importancia al sacrificio y al trabajo duro."
            : "8. El sacrificio y el trabajo duro no son sus puntos fuertes.");
    String resp9 = value9 >= 6
        ? "9. Alta orientación hacia la obtención de estatus y/o prestigio."
        : (value9 > 4 && value9 < 6
        ? "9. Otorga importancia a la obtención de estatus y/o prestigio."
        : "9. Otorga poca importancia a la obtención de estatus y/o prestigio.");
    String resp10 = value10 == 7
        ? "10. Alta orientación hacia la búsqueda de seguridad y estabilidad."
        : (value10 > 5 && value10 < 7
        ? "10. La seguridad y la estabilidad son valores importantes para usted."
        : "10. Poca orientación hacia la búsqueda de seguridad y estabilidad.");

    list.add(resp1);
    list.add(resp2);
    list.add(resp3);
    list.add(resp4);
    list.add(resp5);
    list.add(resp6);
    list.add(resp7);
    list.add(resp8);
    list.add(resp9);
    list.add(resp10);
    return list;
  }
}
