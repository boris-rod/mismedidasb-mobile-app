import 'package:mismedidasb/utils/calendar_utils.dart';

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
  List<FoodGroupModel> foodGroupList;
  bool isExpanded;

  DailyActivityFoodModel(
      {this.id, this.name, this.foodGroupList, this.isExpanded = false});

  static List<DailyActivityFoodModel> getDailyActivityFoodModelList() {
    return [
      DailyActivityFoodModel(
          id: 1,
          name: "Desayuno",
          foodGroupList: FoodGroupModel.getFoodGroupModel()),
      DailyActivityFoodModel(
          id: 2,
          name: "Merienda",
          foodGroupList: FoodGroupModel.getFoodGroupModel()),
      DailyActivityFoodModel(
          id: 3,
          name: "Almuerzo",
          foodGroupList: FoodGroupModel.getFoodGroupModel()),
      DailyActivityFoodModel(
          id: 4,
          name: "Merienda",
          foodGroupList: FoodGroupModel.getFoodGroupModel()),
      DailyActivityFoodModel(
          id: 5,
          name: "Cena",
          foodGroupList: FoodGroupModel.getFoodGroupModel()),
    ];
  }
}

class FoodGroupModel {
  int id;
  String name;
  List<FoodModel> foods;
  bool isExpanded;

  FoodGroupModel(
      {this.id,
      this.name,
      this.foods,
      this.isExpanded = false});

  static List<FoodGroupModel> getFoodGroupModel() {
    return [
      FoodGroupModel(id: 1, name: "Proteinas", foods: [], isExpanded: false),
      FoodGroupModel(id: 1, name: "Vegetales", foods: [], isExpanded: false),
      FoodGroupModel(id: 1, name: "Fibras", foods: [], isExpanded: false),
      FoodGroupModel(id: 1, name: "Bebidas", foods: [], isExpanded: false)
    ];
  }
}

class FoodModel {
  int id;
  String name;
  int calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;
  String image;
  String imageMimeType;
  List<FoodTagModel> tags;

  FoodModel(
      {this.id,
      this.name,
      this.calories,
      this.carbohydrates,
      this.proteins,
      this.fat,
      this.fiber,
        this.image,
        this.imageMimeType,
      this.tags});
}

class FoodTagModel {
  int id;
  String name;

  FoodTagModel({this.id, this.name});
}
