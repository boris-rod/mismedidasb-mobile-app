import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class WellnessResultModel {
  List<MeasureWellnessModel> wellness;
  List<String> result;

  WellnessResultModel({this.wellness, this.result});
}

class MeasureWellnessModel {
  QuestionModel question;
  List<AnswerModel> answers;
  AnswerModel selectedAnswer;

  MeasureWellnessModel({this.question, this.answers, this.selectedAnswer});
}

class WellnessResult {
  static List<String> getResult(WellnessResultModel model) {
    List<String> list = [];

    int value1 = model.wellness[0].selectedAnswer.weight +
        model.wellness[2].selectedAnswer.weight +
        model.wellness[8].selectedAnswer.weight;
    int value2 = model.wellness[3].selectedAnswer.weight +
        model.wellness[5].selectedAnswer.weight +
        model.wellness[9].selectedAnswer.weight;
    int value3 = model.wellness[6].selectedAnswer.weight +
        model.wellness[7].selectedAnswer.weight;
    int value4 = model.wellness[1].selectedAnswer.weight +
        model.wellness[4].selectedAnswer.weight;
    int vGeneral = value1 + value2 + value3 + value4;

    String general = "";
    String resp1 = "";
    String resp2 = "";
    String resp3 = "";
    String resp4 = "";
    String additional = "";

    if (vGeneral >= 44)
      general = "Elevados niveles de bienestar, caracterizado por:";
    else if (vGeneral < 44 && vGeneral >= 34)
      general = "Percepción de bienestar caracterizada por:";
    else
      general = "Bajos niveles de bienestar, caracterizado por:";

    if (value1 >= 14) {
      resp1 = "1. Elevada búsqueda de ocio y diversión.";
    } else if (value1 > 10 && value1 < 14) {
      resp1 = "1. Adecuado manejo del ocio y el tiempo libre.";
    } else
      resp1 = "1. Actividades de ocio escasas o poco gratificantes.";

    if (value2 >= 13) {
      resp2 = "2. Elevada satisfacción consigo mismo.";
    } else if (value2 > 9 && value2 < 13) {
      resp2 = "2. Adecuada satisfacción consigo mismo.";
    } else
      resp2 = "2. Baja satisfacción consigo mismo.";

    if (value3 >= 10) {
      resp3 = "3. Elevada satisfacción con la actividad que realiza.";
    } else if (value3 > 7 && value3 < 10) {
      resp3 = "3. Adecuada satisfacción con la actividad que realiza.";
    } else
      resp3 = "3. Baja satisfacción con la actividad que realiza.";

    if (value4 >= 10) {
      resp4 = "4. Se percibe como una persona muy saludable.";
    } else if (value4 > 6 && value4 < 10) {
      resp4 = "4. Se percibe como una persona saludable.";
    } else
      resp4 = "4. No se percibe como una persona saludable.";

    additional =
        "Total $vGeneral, Hed = $value1, Si mismo = $value2, Activ = $value3, AutoI = $value4";

    list.add(general);
    list.add(resp1);
    list.add(resp2);
    list.add(resp3);
    list.add(resp4);

    return list;
  }
}
