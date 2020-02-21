class QuestionModel {
  int id;
  int pollId;
  int order;
  String title;

  QuestionModel({this.id, this.pollId, this.order, this.title});

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
          id: 5,
          pollId: 3,
          order: 1,
          title: "Realizo actividades divertidas"),
      QuestionModel(
          id: 6,
          pollId: 3,
          order: 2,
          title: "Me siento alegre y risueño"),
      QuestionModel(
          id: 7,
          pollId: 3,
          order: 3,
          title: "Me gusta distraerme y descansar"),
      QuestionModel(
          id: 8,
          pollId: 3,
          order: 4,
          title: "Veo la vida con optimismo"),
      QuestionModel(
          id: 9,
          pollId: 3,
          order: 5,
          title: "Mi salud es buena"),
      QuestionModel(
          id: 10,
          pollId: 3,
          order: 6,
          title: "Logro lo que me propongo"),
      QuestionModel(
          id: 11,
          pollId: 3,
          order: 7,
          title: "Hago las cosas con ilusión"),
      QuestionModel(
          id: 12,
          pollId: 3,
          order: 8,
          title: "Me gusta lo que hago"),
      QuestionModel(
          id: 13,
          pollId: 3,
          order: 9,
          title: "Me gusta relacionarme con la gente"),
      QuestionModel(
          id: 14,
          pollId: 3,
          order: 10,
          title: "Las cosas me van bien")
    ];
    return list;
  }

  static List<QuestionModel> getValues(){
    List<QuestionModel> list = [
      QuestionModel(
          id: 15,
          pollId: 4,
          order: 1,
          title: "Conformmismo / Obediencia"),
      QuestionModel(
          id: 16,
          pollId: 4,
          order: 2,
          title: "Aceptar las costumbres y tradiciones"),
      QuestionModel(
          id: 17,
          pollId: 4,
          order: 3,
          title: "Benevolencia / Servicio / Compasión"),
      QuestionModel(
          id: 18,
          pollId: 4,
          order: 4,
          title: "Proteger la naturaleza y la vida"),
      QuestionModel(
          id: 19,
          pollId: 4,
          order: 5,
          title: "Independencia / Creatividad"),
      QuestionModel(
          id: 20,
          pollId: 4,
          order: 6,
          title: "Riesgo / Aventura"),
      QuestionModel(
          id: 21,
          pollId: 4,
          order: 7,
          title: "Placer / Disfrute / Ocio"),
      QuestionModel(
          id: 22,
          pollId: 4,
          order: 8,
          title: "Trabajo / Esfuerzo / Sacrificio"),
      QuestionModel(
          id: 23,
          pollId: 4,
          order: 9,
          title: "Estatus / Prestigio"),
      QuestionModel(
          id: 23,
          pollId: 4,
          order: 9,
          title: "Segurida / Armonia / Estabilidad"),
    ];

    return list;
  }
}
