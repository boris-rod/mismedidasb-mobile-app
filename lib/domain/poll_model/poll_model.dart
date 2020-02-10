class PollModel {
  int id;
  String name;
  String description;
  String codeName;
  int conceptId;

  PollModel(
      {this.id, this.name, this.description, this.codeName, this.conceptId});

  static PollModel getPollPhysicalExercise(){
    return PollModel(
      id: 1,
      name: "Ejercicio Físico",
      description: "Descripción",
      codeName: "PE",
      conceptId: 1
    );
  }

  static PollModel getPollDiet(){
    return PollModel(
        id: 2,
        name: "Dieta",
        description: "Descripción",
        codeName: "DIE",
        conceptId: 1
    );
  }

  static PollModel getPollWellness(){
    return PollModel(
        id: 3,
        name: "Medidas de bienestar",
        description: "Descripción",
        codeName: "MW",
        conceptId: 2
    );
  }

  static PollModel getPollValues(){
    return PollModel(
        id: 4,
        name: "Medidas de valor",
        description: "Descripción",
        codeName: "MV",
        conceptId: 3
    );
  }
}
