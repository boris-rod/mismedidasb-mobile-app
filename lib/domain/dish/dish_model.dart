import 'package:mismedidasb/utils/calendar_utils.dart';

class DailyFoodPlanModel {
  DateTime dateTime;
  double dailyKCal;
  double imc;

  DailyFoodPlanModel({this.dateTime, this.dailyKCal = 1, this.imc = 1});

  double get breakFastCalVal => dailyKCal * 20 / 100;

  double get snack1CalVal => dailyKCal * 10 / 100;

  double get lunchCalVal => dailyKCal * 35 / 100;

  double get snack2CalVal => dailyKCal * 10 / 100;

  double get dinnerCalVal => dailyKCal * 25 / 100;

  String get breakfastCalStr => "$breakFastCalVal calorías";

  String get snack1CalStr => "$snack1CalVal calorías";

  String get lunchCalStr => "$lunchCalVal calorías";

  String get snack2CalStr => "$snack2CalVal calorías";

  String get dinnerCalStr => "$dinnerCalVal calorías";

  String get imcStr => "Índice de masa corporal ${imc.toStringAsFixed(2)}";

  String get kCalStr => "Calorías diarias $dailyKCal";

  String get kCalRange => imc <= 18.5
      ? "Calorías entre $dailyKCal <-> ${dailyKCal + 500}"
      : (imc > 18.5 && imc < 25
          ? "Calorías entre ${dailyKCal - 100} <-> ${dailyKCal + 100}"
          : "Calorías entre $dailyKCal <-> ${dailyKCal - 500}");
}

class DailyFoodModel {
  DateTime dateTime;
  List<DailyActivityFoodModel> dailyActivityFoodModel;

  DailyFoodModel({this.dateTime, this.dailyActivityFoodModel});

  static DailyFoodModel getDailyFoodModel() {
    return DailyFoodModel(
        dateTime: DateTime.now(),
        dailyActivityFoodModel:
            DailyActivityFoodModel.getDailyActivityFoodModelList());
  }
}

class DailyActivityFoodModel {
  int id;
  String name;
  List<FoodModel> foods;
  bool isExpanded;
  double calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;

  DailyActivityFoodModel(
      {this.id,
      this.name,
      this.foods,
      this.isExpanded = false,
      this.calories = 0,
      this.carbohydrates = 0,
      this.proteins = 0,
      this.fat = 0,
      this.fiber = 0});

  static List<DailyActivityFoodModel> getDailyActivityFoodModelList() {
    return [
      DailyActivityFoodModel(id: 1, name: "Desayuno", foods: []),
      DailyActivityFoodModel(id: 2, name: "Merienda", foods: []),
      DailyActivityFoodModel(id: 3, name: "Almuerzo", foods: []),
      DailyActivityFoodModel(id: 4, name: "Merienda", foods: []),
      DailyActivityFoodModel(id: 5, name: "Cena", foods: []),
    ];
  }
}

class FoodModel {
  int id;
  String name;
  double calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;
  String image;
  String imageMimeType;
  bool isSelected;
  List<TagModel> tags;

  TagModel get tag => tags.isNotEmpty ? tags[0] : TagModel();

  FoodModel({
    this.id,
    this.name,
    this.calories,
    this.carbohydrates,
    this.proteins,
    this.fat,
    this.fiber,
    this.image,
    this.imageMimeType,
    this.tags,
    this.isSelected = false,
  });
}

class TagModel {
  int id;
  String name;
  bool isSelected;

  TagModel({this.id, this.name, this.isSelected = true});
}
