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

//  String get breakfastCalStr => "$breakFastCalVal calorías";
//
//  String get snack1CalStr => "$snack1CalVal calorías";
//
//  String get lunchCalStr => "$lunchCalVal calorías";
//
//  String get snack2CalStr => "$snack2CalVal calorías";
//
//  String get dinnerCalStr => "$dinnerCalVal calorías";
//
//  String get imcStr => "Índice de masa corporal ${imc.toStringAsFixed(2)}";
//
//  String get kCalStr => "Calorías diarias $dailyKCal";
//
//  String get kCalRange => imc <= 18.5
//      ? "Calorías entre $kCalMin <-> $kCalMax"
//      : (imc > 18.5 && imc < 25
//          ? "Calorías entre $kCalMin <-> $kCalMax"
//          : "Calorías entre $kCalMin <-> $kCalMax");
}

class DailyFoodModel {
  DateTime dateTime;
  List<DailyActivityFoodModel> dailyActivityFoodModelList;
  DailyFoodPlanModel dailyFoodPlanModel;
  bool headerExpanded;
  double currentCaloriesSum;
  double currentSumProteins;
  double currentSumCarbohydrates;
  double currentSumFat;
  double currentSumFiber;

  DailyActivityFoodModel get hasFoods =>
      dailyActivityFoodModelList.firstWhere((dA) => dA.foods.isNotEmpty,
          orElse: () {
        return null;
      });

  DailyFoodModel(
      {this.dateTime,
      this.dailyActivityFoodModelList,
      this.dailyFoodPlanModel,
      this.currentCaloriesSum = 0,
      this.currentSumCarbohydrates = 0,
      this.currentSumFat = 0,
      this.currentSumFiber = 0,
      this.currentSumProteins = 0,
      this.headerExpanded = true});

  static DailyFoodModel getDailyFoodModel(double dailyKCal, double imc, DateTime dateTime) {
    final plan = DailyFoodPlanModel(imc: imc, dailyKCal: dailyKCal);
    return DailyFoodModel(
        dateTime: dateTime,
        dailyFoodPlanModel: plan,
        dailyActivityFoodModelList:
            DailyActivityFoodModel.getDailyActivityFoodModelList(plan, dateTime));
  }
}

class DailyActivityFoodModel {
  int id;
  int typeId;
  String type;
  String name;
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

  DailyActivityFoodModel(
      {this.id,
      this.typeId,
      this.type,
      this.name,
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
          id: 0,
          name: R.string.breakfast,
          foods: [],
          plan: dailyFoodPlanModel,
          dateTime: dateTime),
      DailyActivityFoodModel(
          id: 1,
          name: R.string.snack,
          foods: [],
          plan: dailyFoodPlanModel,
          dateTime: dateTime),
      DailyActivityFoodModel(
          id: 2,
          name: R.string.lunch,
          foods: [],
          plan: dailyFoodPlanModel,
          dateTime: dateTime),
      DailyActivityFoodModel(
          id: 3,
          name: R.string.snack,
          foods: [],
          plan: dailyFoodPlanModel,
          dateTime: dateTime),
      DailyActivityFoodModel(
          id: 4,
          name: R.string.dinner,
          foods: [],
          plan: dailyFoodPlanModel,
          dateTime: dateTime),
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
  DateTime dateInUtc;
  List<CreateDailyActivityModel> activities;

  CreateDailyPlanModel({this.dateInUtc, this.activities = const []});
}

class CreateDailyActivityModel {
  int id;
  List<CreateFoodModel> foods;

  CreateDailyActivityModel({this.id, this.foods = const []});
}

class CreateFoodModel {
  int id;
  int quantity;

  CreateFoodModel({this.id, this.quantity = 1});
}
