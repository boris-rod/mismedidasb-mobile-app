import 'package:mismedidasb/domain/answer/answer_model.dart';

class SingleSelectionModel {
  int index;
  int id;
  String displayName;
  bool isSelected;

  SingleSelectionModel(
      {this.index, this.id, this.displayName, this.isSelected});

  static List<SingleSelectionModel> getAgeRange() {
    List<SingleSelectionModel> list = [];
    for (int i = 18; i <= 100; i++) {
      list.add(SingleSelectionModel(
          index: i - 18, id: i, displayName: i.toString(), isSelected: false));
    }
    return list;
  }

  static List<SingleSelectionModel> getWeight() {
    List<SingleSelectionModel> list = [];
    for (int i = 40; i <= 450; i++) {
      list.add(SingleSelectionModel(
          index: i - 40, id: i, displayName: i.toString(), isSelected: false));
    }
    return list;
  }

  static List<SingleSelectionModel> getHeight() {
    List<SingleSelectionModel> list = [];
    for (int i = 100; i <= 230; i++) {
      list.add(SingleSelectionModel(
          index: i - 100, id: i, displayName: i.toString(), isSelected: false));
    }
    return list;
  }

  static List<SingleSelectionModel> getSex() {
    List<SingleSelectionModel> list = [
      SingleSelectionModel(
        index: 0,
        id: 1,
        displayName: "Hombre",
        isSelected: false,
      ),
      SingleSelectionModel(
        index: 1,
        id: 2,
        displayName: "Mujer",
        isSelected: false,
      )
    ];

    return list;
  }

  static List<SingleSelectionModel> getPhysicalExercise() {
    List<SingleSelectionModel> list = [];
    int index = 0;
    AnswerModel.getPhysicalExercise().forEach((data) {
      list.add(SingleSelectionModel(
          id: data.weight, index: index, displayName: data.title));
      index += 1;
    });
    return list;
  }

  static List<SingleSelectionModel> getDiet() {
    List<SingleSelectionModel> list = [];
    int index = 0;
    AnswerModel.getAnswers().forEach((data) {
      list.add(SingleSelectionModel(
          id: data.weight, index: index, displayName: data.title));
      index += 1;
    });
    return list;
  }

  static List<SingleSelectionModel> getWellness() {
    List<SingleSelectionModel> list = [];
    int index = 0;
    AnswerModel.getAnswers().forEach((data) {
      list.add(SingleSelectionModel(
          id: data.id, index: index, displayName: data.title));
      index += 1;
    });
    return list;
  }

  static List<SingleSelectionModel> getValues() {
    List<SingleSelectionModel> list = [];
    int index = 0;
    AnswerModel.getAnswers2().forEach((data) {
      list.add(SingleSelectionModel(
          id: data.id, index: index, displayName: data.title));
      index += 1;
    });
    return list;
  }

  static List<SingleSelectionModel> getMeasures() {
    List<SingleSelectionModel> list = [];
    int index = 0;
    AnswerModel.getAnswers().forEach((data) {
      list.add(SingleSelectionModel(
          id: data.weight, index: index, displayName: data.title));
      index += 1;
    });
    return list;
  }
}
