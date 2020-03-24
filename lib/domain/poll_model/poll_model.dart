import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class PollModel {
  int id;
  String name;
  String description;
  int order;
  bool isReadOnly;
  String readOnlyData;
  int conceptId;
  HealthConceptModel conceptModel;

  PollModel(
      {this.id,
      this.name,
      this.description,
      this.order,
      this.isReadOnly,
      this.readOnlyData,
      this.conceptId,
      this.conceptModel});

  static PollModel getPollPhysicalExercise() {
    return PollModel(
        id: 1,
        name: "Ejercicio Físico",
        description: "Descripción",
        conceptId: 1);
  }

  static PollModel getPollDiet() {
    return PollModel(
        id: 2, name: "Dieta", description: "Descripción", conceptId: 1);
  }

  static PollModel getPollWellness() {
    return PollModel(
        id: 3,
        name: "Medidas de bienestar",
        description: "Descripción",
        conceptId: 2);
  }

  static PollModel getPollValues() {
    return PollModel(
        id: 4,
        name: "Medidas de valor",
        description: "Descripción",
        conceptId: 3);
  }
}

class PollResultModel {
  int pollId;
  List<QuestionResultModel> questionsResults;

  PollResultModel({this.pollId, this.questionsResults});
}
