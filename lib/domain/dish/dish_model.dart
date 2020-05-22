import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class DailyFoodPlanModel {
  double dailyKCal;
  double imc;

  DailyFoodPlanModel({this.dailyKCal = 1, this.imc = 1});

  double get kCalOffSetVal => (imc > 18.5 && imc < 25) ? 100 : 500;

  double get breakFastCalVal => dailyKCal * 20 / 100;

  double get breakFastCalValExtra => kCalOffSetVal * 20 / 100;

  double get snack1CalVal => dailyKCal * 10 / 100;

  double get snack1CalValExtra => kCalOffSetVal * 10 / 100;

  double get lunchCalVal => dailyKCal * 35 / 100;

  double get lunchCalValExtra => kCalOffSetVal * 35 / 100;

  double get snack2CalVal => dailyKCal * 10 / 100;

  double get snack2CalValExtra => kCalOffSetVal * 10 / 100;

  double get dinnerCalVal => dailyKCal * 25 / 100;

  double get dinnerCalValExtra => kCalOffSetVal * 25 / 100;

  double get kCalMin => imc <= 18.5
      ? dailyKCal
      : (imc > 18.5 && imc < 25 ? dailyKCal - 100 : dailyKCal - 500);

  double get kCalMax => imc <= 18.5
      ? dailyKCal + 500
      : (imc > 18.5 && imc < 25 ? dailyKCal + 100 : dailyKCal);
}

class DailyFoodModel {
  DateTime dateTime;
  List<DailyActivityFoodModel> dailyActivityFoodModelList;
  DailyFoodPlanModel dailyFoodPlanModel;
  bool synced;
  bool headerExpanded;
  bool showKCalPercentages;
  double currentCaloriesSum;
  double currentSumProteins;
  double currentSumCarbohydrates;
  double currentSumFat;
  double currentSumFiber;

  double get currentCaloriesSumTest => dailyActivityFoodModelList
      .map((d) => d.calories)
      .reduce((v1, v2) => v1 + v2);

  DailyActivityFoodModel get hasFoods => dailyActivityFoodModelList
          .firstWhere((dA) => dA.foods.isNotEmpty, orElse: () {
        return null;
      });

  DailyFoodModel(
      {this.dateTime,
      this.synced = true,
      this.dailyActivityFoodModelList,
      this.dailyFoodPlanModel,
      this.currentCaloriesSum = 0,
      this.currentSumCarbohydrates = 0,
      this.currentSumFat = 0,
      this.currentSumFiber = 0,
      this.currentSumProteins = 0,
      this.headerExpanded = true,
      this.showKCalPercentages = false});
}

class DailyActivityFoodModel {
  int id;
  String type;
  List<FoodModel> foods;
  double calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;
  DailyFoodPlanModel plan;
  DateTime dateTime;
  bool isExpanded;

  int foodsProteinsPercentage;
  int foodsCarbohydratesPercentage;
  int foodsFiberPercentage;

  double proteinsDishCalories;
  double fiberDishCalories;
  double carbohydratesDishCalories;

  String get name => id == 0
      ? R.string.breakfast
      : (id == 1
          ? R.string.snack1
          : (id == 2
              ? R.string.lunch
              : (id == 3 ? R.string.snack2 : R.string.dinner)));

  DailyActivityFoodModel(
      {this.id,
      this.type,
      this.foods,
      this.calories = 0,
      this.carbohydrates = 0,
      this.proteins = 0,
      this.fat = 0,
      this.fiber = 0,
      this.dateTime,
      this.plan,
      this.isExpanded = true});

  static List<DailyActivityFoodModel> getDailyActivityFoodModelList(
      DailyFoodPlanModel dailyFoodPlanModel, DateTime dateTime) {
    return [
      DailyActivityFoodModel(
          id: 0, foods: [], plan: dailyFoodPlanModel, dateTime: dateTime),
      DailyActivityFoodModel(
          id: 1, foods: [], plan: dailyFoodPlanModel, dateTime: dateTime),
      DailyActivityFoodModel(
          id: 2, foods: [], plan: dailyFoodPlanModel, dateTime: dateTime),
      DailyActivityFoodModel(
          id: 3, foods: [], plan: dailyFoodPlanModel, dateTime: dateTime),
      DailyActivityFoodModel(
          id: 4, foods: [], plan: dailyFoodPlanModel, dateTime: dateTime),
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

  double get caloriesFixed => carbohydrates * 4 + proteins * 4 + fat * 9;

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

class CreateDailyPlanModel {
  DateTime dateTime;
  List<CreateDailyActivityModel> activities;

  CreateDailyPlanModel({this.dateTime, this.activities = const []});

  static CreateDailyPlanModel fromDailyFoodModel(DailyFoodModel model) {
    return CreateDailyPlanModel(
        dateTime: model.dateTime,
        activities: model.dailyActivityFoodModelList
            .map((a) => CreateDailyActivityModel.fromDailyActivityFoodModel(a))
            .toList());
  }
}

class CreateDailyActivityModel {
  int id;
  List<CreateFoodModel> foods;

  CreateDailyActivityModel({this.id, this.foods = const []});

  static CreateDailyActivityModel fromDailyActivityFoodModel(
      DailyActivityFoodModel model) {
    return CreateDailyActivityModel(
        id: model.id,
        foods:
            model.foods.map((f) => CreateFoodModel.fromFoodModel(f)).toList());
  }
}

class CreateFoodModel {
  int id;
  int quantity;

  CreateFoodModel({this.id, this.quantity = 1});

  static CreateFoodModel fromFoodModel(FoodModel model) {
    return CreateFoodModel(id: model.id, quantity: 1);
  }
}
