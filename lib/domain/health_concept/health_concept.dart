class HealthConceptModel {
  int id;
  String title;
  String description;
  String codeName;
  String image;

  HealthConceptModel({this.id, this.title, this.description, this.codeName, this.image});

  static HealthConceptModel getHealth(){
    return HealthConceptModel(
        id: 1,
        title: "Medidas de salud",
        description: "Descripción",
        codeName: "HM");
  }

  static HealthConceptModel getWellness(){
    return HealthConceptModel(
        id: 2,
        title: "Medidas de bienestar",
        description: "Descripción",
        codeName: "MW");
  }

  static HealthConceptModel getValues(){
    return HealthConceptModel(
        id: 3,
        title: "Medidas de valor",
        description: "Descripción",
        codeName: "MV");
  }

  static HealthConceptModel getHabits(){
    return HealthConceptModel(
        id: 4,
        title: "Medidas de valor",
        description: "Descripción",
        codeName: "MH");
  }
}
