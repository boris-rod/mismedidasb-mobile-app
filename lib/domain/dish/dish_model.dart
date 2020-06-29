import 'package:mismedidasb/domain/single_selection_model.dart';
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
  double currentProteinsSum;
  double currentCarbohydratesSum;
  double currentFatSum;
  double currentFiberSum;

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
      this.currentCarbohydratesSum = 0,
      this.currentFatSum = 0,
      this.currentFiberSum = 0,
      this.currentProteinsSum = 0,
      this.headerExpanded = true,
      this.showKCalPercentages = false});
}

class DailyActivityFoodModel {
  int id;
  String type;
  List<FoodModel> foods;
  DailyFoodPlanModel plan;
  DateTime dateTime;
  bool isExpanded;

  double calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;

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

//  double activityCalories() {
//    double cal = 0;
//    foods.forEach((f) {
//      cal += f.caloriesFixed;
//    });
//    return cal;
//  }

  double get activityCalories => foods.isEmpty
      ? 0.0
      : foods.length == 1
          ? foods[0].caloriesFixed
          : foods
              .map((f) => f.caloriesFixed)
              .toList()
              .reduce((c1, c2) => c1 + c2);

  double get getActivityFoodCaloriesOffSet => id == 0
      ? plan.breakFastCalValExtra
      : (id == 1
          ? plan.snack1CalValExtra
          : (id == 2
              ? plan.lunchCalValExtra
              : (id == 3 ? plan.snack2CalValExtra : plan.dinnerCalValExtra)));

  double get getCurrentCaloriesPercentageByFood =>
      activityCalories *
      100 /
      (getActivityFoodCalories + getActivityFoodCaloriesOffSet);

  double get getActivityFoodCalories => id == 0
      ? plan.breakFastCalVal
      : (id == 1
          ? plan.snack1CalVal
          : (id == 2
              ? plan.lunchCalVal
              : (id == 3 ? plan.snack2CalVal : plan.dinnerCalVal)));

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
  bool isProteic;
  bool isCaloric;
  bool isFruitAndVegetables;
  double calories;
  double carbohydrates;
  double proteins;
  double fat;
  double fiber;
  String image;
  String imageMimeType;
  bool isSelected;
  List<FoodModel> children;
  List<TagModel> tags;
  double count;

  TagModel get tag => tags?.isNotEmpty == true ? tags[0] : TagModel();

  double get caloriesFixed =>
      (carbohydrates * 4 + proteins * 4 + fat * 9) * count;

  bool get isCompound =>
      children.isNotEmpty && (children.length > 1 || children[0].count > 1);

  String get displayCount => count == 0.25
      ? "1/4"
      : (count == 0.50
          ? "1/2"
          : (count == 0.75 ? "3/4" : count.truncate().toString()));

  List<SingleSelectionModel> get availableCounts => [
        SingleSelectionModel(
            id: 1,
            index: 0,
            partialValue: 0.25,
            displayName: "1/4",
            isSelected: true),
        SingleSelectionModel(
            id: 2,
            index: 1,
            partialValue: 0.50,
            displayName: "1/2",
            isSelected: true),
        SingleSelectionModel(
            id: 3,
            index: 2,
            partialValue: 0.75,
            displayName: "3/4",
            isSelected: true),
        SingleSelectionModel(
            id: 4,
            index: 3,
            partialValue: 1,
            displayName: "1",
            isSelected: true),
        SingleSelectionModel(
            id: 5,
            index: 4,
            displayName: "2",
            partialValue: 2,
            isSelected: true),
        SingleSelectionModel(
            id: 6,
            index: 5,
            displayName: "3",
            partialValue: 3,
            isSelected: true),
        SingleSelectionModel(
            id: 7,
            index: 6,
            displayName: "4",
            partialValue: 4,
            isSelected: true),
        SingleSelectionModel(
            id: 8,
            index: 7,
            displayName: "5",
            partialValue: 5,
            isSelected: true),
      ];

  FoodModel(
      {this.id,
      this.name = "",
      this.isProteic,
      this.isCaloric,
      this.isFruitAndVegetables,
      this.calories,
      this.carbohydrates,
      this.proteins,
      this.fat,
      this.fiber,
      this.image = "",
      this.imageMimeType,
      this.tags,
      this.isSelected = false,
      this.count = 1,
      this.children = const []});
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
  bool isBalanced;

  CreateDailyPlanModel(
      {this.dateTime, this.activities = const [], this.isBalanced});

  static CreateDailyPlanModel fromDailyFoodModel(DailyFoodModel model) {
    bool isBalancedPlan = false;
    bool kCalAll =
        model.currentCaloriesSum > model.dailyFoodPlanModel.kCalMin &&
            model.currentCaloriesSum <= model.dailyFoodPlanModel.kCalMax;

    double proteinPer = model.currentProteinsSum *
        100 /
        (model.dailyFoodPlanModel.kCalMax * 25 / 100);
    bool proteins = proteinPer <= 100 && proteinPer > (12 * 100 / 25);

    double carbohydratesPer = model.currentCarbohydratesSum *
        100 /
        (model.dailyFoodPlanModel.kCalMax * 55 / 100);
    bool carbohydrates =
        carbohydratesPer <= 100 && carbohydratesPer > 35 * 100 / 55;

    double fatPer = model.currentFatSum *
        100 /
        (model.dailyFoodPlanModel.kCalMax * 35 / 100);
    bool fat = fatPer <= 100 && fatPer > 20 * 100 / 35;

    double fibPer = model.currentFiberSum * 100 / 50;
    bool fiber = fibPer <= 100 && fibPer > 30 * 100 / 50;

    double breakfastKcalPer = model.dailyActivityFoodModelList[0].calories *
        100 /
        (model.dailyFoodPlanModel.breakFastCalVal +
            model.dailyFoodPlanModel.breakFastCalValExtra);
    bool breakfastKcal = model.dailyActivityFoodModelList[0].calories >=
            (model.dailyFoodPlanModel.breakFastCalVal -
                model.dailyFoodPlanModel.breakFastCalValExtra) &&
        breakfastKcalPer < 101;

    double snack1KcalPer = model.dailyActivityFoodModelList[1].calories * 100 / (model.dailyFoodPlanModel.snack1CalVal +
        model.dailyFoodPlanModel.snack1CalValExtra);
    bool snack1Kcal = model.dailyActivityFoodModelList[1].calories >=
            (model.dailyFoodPlanModel.snack1CalVal -
                model.dailyFoodPlanModel.snack1CalValExtra) && snack1KcalPer < 101;

    double lunchKcalPer = model.dailyActivityFoodModelList[2].calories * 100 / (model.dailyFoodPlanModel.lunchCalVal +
        model.dailyFoodPlanModel.lunchCalValExtra);
    bool lunchKcal = model.dailyActivityFoodModelList[2].calories >=
            (model.dailyFoodPlanModel.lunchCalVal -
                model.dailyFoodPlanModel.lunchCalValExtra) && lunchKcalPer < 101;

    double snack2KcalPer = model.dailyActivityFoodModelList[3].calories * 100 / (model.dailyFoodPlanModel.snack2CalVal +
        model.dailyFoodPlanModel.snack2CalValExtra);
    bool snack2Kcal = model.dailyActivityFoodModelList[3].calories >=
            (model.dailyFoodPlanModel.snack2CalVal -
                model.dailyFoodPlanModel.snack2CalValExtra) && snack2KcalPer < 101;

    double dinnerKcalPer = model.dailyActivityFoodModelList[4].calories * 100 / (model.dailyFoodPlanModel.dinnerCalVal +
        model.dailyFoodPlanModel.dinnerCalValExtra);
    bool dinnerKcal = model.dailyActivityFoodModelList[4].calories >=
            (model.dailyFoodPlanModel.dinnerCalVal -
                model.dailyFoodPlanModel.dinnerCalValExtra) && dinnerKcalPer < 101;

    isBalancedPlan = kCalAll &&
        proteins &&
        carbohydrates &&
        fat &&
        fiber &&
        breakfastKcal &&
        snack1Kcal &&
        lunchKcal &&
        snack2Kcal &&
        dinnerKcal;

    return CreateDailyPlanModel(
        dateTime: model.dateTime,
        isBalanced: isBalancedPlan,
        activities: model.dailyActivityFoodModelList
            .map((a) => CreateDailyActivityModel.fromDailyActivityFoodModel(a))
            .toList());
  }
}

class CreateDailyActivityModel {
  int id;
  List<CreateFoodModel> foods;
  List<CreateFoodModel> foodsCompound;

  CreateDailyActivityModel(
      {this.id, this.foods = const [], this.foodsCompound = const []});

  static CreateDailyActivityModel fromDailyActivityFoodModel(
      DailyActivityFoodModel model) {
    return CreateDailyActivityModel(
      id: model.id,
      foods: model.foods
          .where((f) => !f.isCompound)
          .toList()
          .map((f) => CreateFoodModel.fromFoodModel(f))
          .toList(),
      foodsCompound: model.foods
          .where((f) => f.isCompound)
          .toList()
          .map((f) => CreateFoodModel.fromFoodModel(f))
          .toList(),
    );
  }
}

class CreateFoodCompoundModel {
  String name;
  String image;
  List<CreateFoodModel> foods;

  CreateFoodCompoundModel({this.name, this.image, this.foods});

  static CreateFoodCompoundModel fromFoodModel(FoodModel model) {
    return CreateFoodCompoundModel(
        image: model.image,
        name: model.name,
        foods: model.children
            .map((f) => CreateFoodModel.fromFoodModel(f))
            .toList());
  }
}

class CreateFoodModel {
  int id;
  double quantity;

  CreateFoodModel({this.id, this.quantity = 1});

  static CreateFoodModel fromFoodModel(FoodModel model) {
    return CreateFoodModel(id: model.id, quantity: model.count);
  }
}
