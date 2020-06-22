import 'package:mismedidasb/domain/answer/answer_model.dart';

class SingleSelectionModel {
  int index;
  int id;
  String displayName;
  bool isSelected;
  double partialValue;

  SingleSelectionModel(
      {this.index,
      this.id,
      this.displayName,
      this.isSelected,
      this.partialValue});

//  static List<SingleSelectionModel> getAgeRange() {
//    List<SingleSelectionModel> list = [];
//    for (int i = 18; i <= 100; i++) {
//      list.add(SingleSelectionModel(
//          index: i - 18, id: i, displayName: i.toString(), isSelected: false));
//    }
//    return list;
//  }
//
//  static List<SingleSelectionModel> getWeight() {
//    List<SingleSelectionModel> list = [];
//    for (int i = 40; i <= 450; i++) {
//      list.add(SingleSelectionModel(
//          index: i - 40, id: i, displayName: i.toString(), isSelected: false));
//    }
//    return list;
//  }
//
//  static List<SingleSelectionModel> getHeight() {
//    List<SingleSelectionModel> list = [];
//    for (int i = 100; i <= 230; i++) {
//      list.add(SingleSelectionModel(
//          index: i - 100, id: i, displayName: i.toString(), isSelected: false));
//    }
//    return list;
//  }
//
//  static List<SingleSelectionModel> getSex() {
//    List<SingleSelectionModel> list = [
//      SingleSelectionModel(
//        index: 0,
//        id: 1,
//        displayName: "Hombre",
//        isSelected: false,
//      ),
//      SingleSelectionModel(
//        index: 1,
//        id: 2,
//        displayName: "Mujer",
//        isSelected: false,
//      )
//    ];
//
//    return list;
//  }
//
//  static List<SingleSelectionModel> getPhysicalExercise() {
//    List<SingleSelectionModel> list = [];
//    int index = 0;
//    AnswerModel.getPhysicalExercise().forEach((data) {
//      list.add(SingleSelectionModel(
//          id: data.weight, index: index, displayName: data.title));
//      index += 1;
//    });
//    return list;
//  }
//
//  static List<SingleSelectionModel> getDiet() {
//    List<SingleSelectionModel> list = [];
//    int index = 0;
//    AnswerModel.getAnswers().forEach((data) {
//      list.add(SingleSelectionModel(
//          id: data.weight, index: index, displayName: data.title));
//      index += 1;
//    });
//    return list;
//  }
//
//  static List<SingleSelectionModel> getWellness() {
//    List<SingleSelectionModel> list = [];
//    int index = 0;
//    AnswerModel.getAnswers().forEach((data) {
//      list.add(SingleSelectionModel(
//          id: data.id, index: index, displayName: data.title));
//      index += 1;
//    });
//    return list;
//  }
//
//  static List<SingleSelectionModel> getValues() {
//    List<SingleSelectionModel> list = [];
//    int index = 0;
//    AnswerModel.getAnswers2().forEach((data) {
//      list.add(SingleSelectionModel(
//          id: data.id, index: index, displayName: data.title));
//      index += 1;
//    });
//    return list;
//  }
//
//  static List<SingleSelectionModel> getMeasures() {
//    List<SingleSelectionModel> list = [];
//    int index = 0;
//    AnswerModel.getAnswers().forEach((data) {
//      list.add(SingleSelectionModel(
//          id: data.weight, index: index, displayName: data.title));
//      index += 1;
//    });
//    return list;
//  }
}

class TitleSubTitlesModel {
  int number;
  String title;
  List<String> subTitles;

  TitleSubTitlesModel({
    this.number,
    this.title,
    this.subTitles,
  });

  static List<TitleSubTitlesModel> getHabitsLiterals() {
    List<TitleSubTitlesModel> habits = [];
    habits.add(TitleSubTitlesModel(
        number: 1,
        title: "Planifique 5 comidas por día:",
        subTitles: ["Desayuno / Tentempié / Comida / Merienda / Cena."]));

    habits.add(TitleSubTitlesModel(
        number: 2,
        title: "Distribuya su consumo calórico diario:",
        subTitles: [
          "50-60% Hidratos de Carbono.",
          "30-35% Grasas.",
          "10-15% Proteínas."
        ]));

    habits.add(TitleSubTitlesModel(
        number: 3,
        title: "Ingiera frutas y vegetales a diario:",
        subTitles: ["Ej. naranja, fresas, lechuga o tomate."]));

    habits.add(TitleSubTitlesModel(
        number: 4,
        title: "Coma despacio y mastique bien los alimentos:",
        subTitles: ["Evite ver TV o revisar el móvil mientras come."]));

    habits.add(TitleSubTitlesModel(
        number: 5,
        title: "Beba alrededor de 2 litros de agua durante el día:",
        subTitles: ["Evitar bebidas azucaradas y bebidas energéticas."]));

    habits.add(TitleSubTitlesModel(
        number: 6,
        title: "Fomente la actividad física diaria:",
        subTitles: ["Ej. caminar, subir escaleras o pasear en bici."]));

    habits.add(TitleSubTitlesModel(
        number: 7,
        title: "Realice ejercicio físico regularmente:",
        subTitles: ["Ej. 3 veces por semana (30-45 minutos por sesión)."]));

    habits.add(TitleSubTitlesModel(
        number: 8,
        title: "Reduzca el consumo de alcohol:",
        subTitles: [
          "No beba a diario, debe haber días de abstinencia.",
          "Máximo una o dos copas de vino o botellines de cerveza."
        ]));

    habits.add(TitleSubTitlesModel(
        number: 9,
        title: "Establezca límites para el uso del teléfono móvil:",
        subTitles: [
          "Puede perder alrededor de 4 horas de su día.",
          "Pase más tiempo conectado con la familia o amigos."
        ]));

    habits.add(TitleSubTitlesModel(
        number: 10,
        title: "Fomente un ocio saludable:",
        subTitles: ["Pasee al aire libre con su familia o amigos."]));
    return habits;
  }

  static List<TitleSubTitlesModel> getCravingLiterals() {
    List<TitleSubTitlesModel> cravings = [];

    cravings.add(TitleSubTitlesModel(
        number: 1,
        title: "Dar un paseo caminando durante 15 o 20 minutos.",
        subTitles: []));
    cravings.add(TitleSubTitlesModel(
        number: 2,
        title:
            "FBeber un vaso de agua a sorbos peque&ntilde;os durante 20 minutos.",
        subTitles: []));
    cravings.add(TitleSubTitlesModel(
        number: 3,
        title:
            "Describa sus metas, proyectos y aspiraciones en una extensión no mayor a un folio.",
        subTitles: []));
    cravings.add(TitleSubTitlesModel(
        number: 4, title: "Jugar al Tetris de 3-5 minutos.", subTitles: []));
    cravings.add(TitleSubTitlesModel(
        number: 5,
        title:
            "Imagine lo más vívidamente posible una de las siguientes opciones durante 5 minutos:",
        subTitles: [
          "que está realizando su actividad favorita.",
          "el olor a eucalipto, pomada china o menta.",
          "que come el alimento deseado 33 veces, a razón de 1 porción cada vez."
        ]));

    return cravings;
  }
}
