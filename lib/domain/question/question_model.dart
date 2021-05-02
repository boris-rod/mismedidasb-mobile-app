import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';

class QuestionModel {
  int id;
  int pollId;
  int order;
  String title;
  List<AnswerModel> answers;
  int lastAnswer;
  int selectedAnswerId;

  QuestionModel(
      {this.id,
      this.pollId,
      this.order,
      this.title,
      this.answers,
      this.lastAnswer,
      this.selectedAnswerId = -1});

  List<SingleSelectionModel> convertAnswersToSelectionModel(
      {bool forPounds = false, bool forFeet = false}) {
    List<SingleSelectionModel> list = [];
    for (int i = 0; i < answers.length; i++) {
      list.add(SingleSelectionModel(
          index: i,
          id: answers[i].id,
          displayName: forPounds
              ? (int.tryParse(answers[i].title) * 2.2).toStringAsFixed(0)
              : forFeet
                  ? (int.tryParse(answers[i].title) * 0.0328084).toStringAsFixed(2)
                  : answers[i].title,
          isSelected: false));
    }
    return list;
  }

  static List<QuestionModel> getPhysicalExerciseList() {
    List<QuestionModel> list = [
      QuestionModel(
          id: 1,
          pollId: 1,
          order: 1,
          title: "Con qué frecuencia realiza ejercicios físicos"),
    ];
    return list;
  }

  static List<QuestionModel> getDiets() {
    List<QuestionModel> list = [
      QuestionModel(
          id: 2,
          pollId: 2,
          order: 1,
          title: "Hago dietas que  prometen resultados a corto plazo"),
      QuestionModel(
          id: 3,
          pollId: 2,
          order: 2,
          title: "Comienzo dietas que luego abandono"),
      QuestionModel(
          id: 4,
          pollId: 2,
          order: 3,
          title: "Temrino ganando más peso del que perdí")
    ];
    return list;
  }

  static List<QuestionModel> getWellness() {
    List<QuestionModel> list = [
      QuestionModel(
          id: 5, pollId: 3, order: 1, title: "Realizo actividades divertidas"),
      QuestionModel(
          id: 6, pollId: 3, order: 2, title: "Me siento alegre y risueño"),
      QuestionModel(
          id: 7, pollId: 3, order: 3, title: "Me gusta distraerme y descansar"),
      QuestionModel(
          id: 8, pollId: 3, order: 4, title: "Veo la vida con optimismo"),
      QuestionModel(id: 9, pollId: 3, order: 5, title: "Mi salud es buena"),
      QuestionModel(
          id: 10, pollId: 3, order: 6, title: "Logro lo que me propongo"),
      QuestionModel(
          id: 11, pollId: 3, order: 7, title: "Hago las cosas con ilusión"),
      QuestionModel(id: 12, pollId: 3, order: 8, title: "Me gusta lo que hago"),
      QuestionModel(
          id: 13,
          pollId: 3,
          order: 9,
          title: "Me gusta relacionarme con la gente"),
      QuestionModel(
          id: 14, pollId: 3, order: 10, title: "Las cosas me van bien")
    ];
    return list;
  }

  static List<QuestionModel> getValues() {
    List<QuestionModel> list = [
      QuestionModel(
          id: 15,
          pollId: 4,
          order: 1,
          title:
              "Tendencia hacia el control de acciones, inclinaciones o impulsos que puedan perturbar o dañar a otros, violar las normas o un comportamiento socialmente esperado."),
      QuestionModel(
          id: 16,
          pollId: 4,
          order: 2,
          title:
              "Orientación hacia el respeto, compromiso y aceptación de las costumbres y las ideas promovidas por la propia cultura o religión."),
      QuestionModel(
          id: 17,
          pollId: 4,
          order: 3,
          title:
              "Orientación hacia el cuidado del bienestar de aquellos con los que se tiene un contacto interpersonal frecuente."),
      QuestionModel(
          id: 18,
          pollId: 4,
          order: 4,
          title:
              "Orientación hacia la comprensión, apreciación, tolerancia y protección del bienestar de todas las personas y la naturaleza."),
      QuestionModel(
          id: 19,
          pollId: 4,
          order: 5,
          title:
              "Orientación hacia la independencia de pensamiento y acción, para elegir, crear y explorar."),
      QuestionModel(
          id: 20,
          pollId: 4,
          order: 6,
          title:
              "Orientación hacia la búsqueda constante de vivencias novedosas, excitantes y retos."),
      QuestionModel(
          id: 21,
          pollId: 4,
          order: 7,
          title: "Orientación hacia el placer y la gratificación sensorial."),
      QuestionModel(
          id: 22,
          pollId: 4,
          order: 8,
          title:
              "Orientación hacia el éxito individual mediante la demostración de competencias, adecuadas con los estándares sociales."),
      QuestionModel(
          id: 23,
          pollId: 4,
          order: 9,
          title:
              "Orientación hacia la búsqueda de estatus social y prestigio, implica ejercer el control o la dominación sobre personas y recursos."),
      QuestionModel(
          id: 23,
          pollId: 4,
          order: 9,
          title:
              "Orientación hacia la búsqueda de seguridad, armonía y estabilidad tanto individual como en las relaciones interpersonales."),
    ];

    return list;
  }
}

class QuestionResultModel {
  int questionId;
  int answerId;

  QuestionResultModel({this.questionId, this.answerId});
}

class SoloQuestionModel {
  int index;
  int id;
  String code;
  String title;
  String titleEN;
  String titleIT;
  bool allowCustomAnswer;
  List<SoloAnswerModel> soloAnswers;
  SoloAnswerModel soloAnswerModelSelected;

  SoloQuestionModel(
      {this.id,
      this.index,
      this.code,
      this.title,
      this.soloAnswerModelSelected,
      this.titleIT,
      this.titleEN,
      this.allowCustomAnswer,
      this.soloAnswers});

  List<SingleSelectionModel> convertAnswersToSelectionModel() {
    List<SingleSelectionModel> list = [];
    for (int i = 0; i < soloAnswers.length; i++) {
      list.add(SingleSelectionModel(
          index: i,
          id: soloAnswers[i].id,
          displayName: soloAnswers[i].title,
          isSelected: false));
    }
    return list;
  }
}

class SoloAnswerModel {
  int id;
  int soloQuestionId;
  String code;
  String title;
  String titleEN;
  String titleIT;
  int points;

  SoloAnswerModel(
      {this.id,
      this.soloQuestionId,
      this.code,
      this.title,
      this.titleEN,
      this.titleIT,
      this.points});
}

class SoloAnswerCreateModel {
  int index;
  String questionCode;
  String answerCode;
  String answerValue;

  SoloAnswerCreateModel(
      {this.answerCode, this.answerValue, this.questionCode, this.index});
}

class SingleSelectionSoloModel {
  String questionTitle;
}
