class AnswerModel {
  int id;
  int questionId;
  String title;
  int weight;
  int order;

  AnswerModel({this.id, this.questionId, this.title, this.weight, this.order});

  static List<AnswerModel> getPhysicalExercise() {
    List<AnswerModel> list = [
      AnswerModel(
          id: 1,
          questionId: 1,
          title: "Nunca / Casi nunca",
          weight: 1,
          order: 1),
      AnswerModel(
          id: 2,
          questionId: 1,
          title: "1-3 días por semana",
          weight: 2,
          order: 2),
      AnswerModel(
          id: 3,
          questionId: 1,
          title: "4-5 días por semana",
          weight: 3,
          order: 3),
      AnswerModel(
          id: 4, questionId: 1, title: "Todos los días", weight: 4, order: 4),
      AnswerModel(
          id: 5, questionId: 1, title: "2 veces por día", weight: 5, order: 1),
    ];

    return list;
  }

  static List<AnswerModel> getAnswers() {
    List<AnswerModel> list = [
      AnswerModel(
          id: 6,
          questionId: 2,
          title: "Nunca / Casi nunca",
          weight: 1,
          order: 1),
      AnswerModel(
          id: 7, questionId: 1, title: "Algunas veces", weight: 2, order: 2),
      AnswerModel(
          id: 8, questionId: 1, title: "Muchas veces", weight: 3, order: 3),
      AnswerModel(
          id: 9, questionId: 1, title: "Casi siempre", weight: 4, order: 4),
      AnswerModel(id: 5, questionId: 1, title: "Siempre", weight: 5, order: 5),
    ];

    return list;
  }

  static List<AnswerModel> getAnswers2() {
    List<AnswerModel> list = [
      AnswerModel(
          id: 6,
          questionId: 2,
          title: "Opuesto a mis principios",
          weight: -1,
          order: 1),
      AnswerModel(
          id: 2, questionId: 1, title: "Nada importante", weight: 0, order: 2),
      AnswerModel(
          id: 3,
          questionId: 1,
          title: "Escasamente importante",
          weight: 1,
          order: 3),
      AnswerModel(
          id: 4, questionId: 1, title: "Poco importante", weight: 2, order: 4),
      AnswerModel(
          id: 5, questionId: 1, title: "Algo importante", weight: 3, order: 1),
      AnswerModel(
          id: 5,
          questionId: 1,
          title: "Medianamente importante",
          weight: 4,
          order: 1),
      AnswerModel(
          id: 5, questionId: 1, title: "Importante", weight: 5, order: 1),
      AnswerModel(
          id: 5, questionId: 1, title: "Muy importante", weight: 6, order: 1),
      AnswerModel(
          id: 5,
          questionId: 1,
          title: "Importancia suprema",
          weight: 7,
          order: 1),
    ];

    return list;
  }
}
