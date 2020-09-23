import 'dart:convert';

import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';

class DishConverter extends IDishConverter {
  @override
  DailyFoodModel fromJsonDailyFoodModel(Map<String, dynamic> json) {
    return DailyFoodModel(
        dateTime: DateTime.parse(json["dateTime"]),
        synced: json["synced"],
        dailyFoodPlanModel: fromJsonDailyFoodPlan(json["dailyFoodPlanModel"]),
        dailyActivityFoodModelList:
            (json['dailyActivityFoodModelList'] as List<dynamic>)
                .map((model) =>
                    fromJsonDailyActivityFoodModel(model, fromAPI: false))
                .toList());
  }

  @override
  Map<String, dynamic> toJsonDailyFoodModel(DailyFoodModel model) {
    return {
      "dateTime": model.dateTime.toIso8601String(),
      "synced": model.synced,
      "dailyFoodPlanModel": toJsonDailyFoodPlan(model.dailyFoodPlanModel),
      "dailyActivityFoodModelList": model.dailyActivityFoodModelList
          .map((d) => toJsonDailyActivityFoodModel(d))
          .toList(),
    };
  }

  @override
  DailyActivityFoodModel fromJsonDailyActivityFoodModel(
      Map<String, dynamic> json,
      {bool fromAPI = true}) {
    return DailyActivityFoodModel(
        id: json["eatTypeId"],
//        name: json["name"],
//        typeId: json["eatTypeId"],
        type: json["eatType"],
//        imc: json["imc"] ?? 1,
//        kCal: json["kCal"] ?? 1,
        dateTime: fromAPI
            ? DateTime.parse(json["createdAt"]).toLocal()
            : DateTime.parse(json["dateTime"]),
        plan: !fromAPI ? fromJsonDailyFoodPlan(json["plan"]) : null,
        foods: fromAPI
            ? _getFoodsFromApi(json["eatDishResponse"] as List<dynamic>,
                json["eatCompoundDishResponse"] as List<dynamic>)
            : (json["foods"] as List<dynamic>)
                .map((model) => fromJsonFoodModel(model, fromAPI: fromAPI))
                .toList()
//        foods: (json[fromAPI ? "eatDishResponse" : "foods"] as List<dynamic>)
//            .map((model) => fromAPI
//                ? fromJsonFoodModelWithQTY(model)
//                : fromJsonFoodModel(model))
//            .toList()

        );
  }

  List<FoodModel> _getFoodsFromApi(
      List<dynamic> jsonFoods, List<dynamic> jsonFoodsCompound) {
    List<FoodModel> list = [
      ...jsonFoods.map((f) => fromJsonFoodModelWithQTY(f)).toList(),
      ...jsonFoodsCompound.map((f) => fromJsonFoodModelWithQTY(f)).toList(),
    ];

    return list;
  }

  @override
  FoodModel fromJsonFoodModelWithQTY(Map<String, dynamic> json) {
    final food = fromJsonFoodModel(
        json.containsKey("dish") ? json["dish"] : json["compoundDish"]);
    food.count = json["qty"] * 1.0;
    return food;
  }

  @override
  Map<String, dynamic> toJsonDailyActivityFoodModel(
      DailyActivityFoodModel model) {
    return {
      "eatTypeId": model.id,
//      "name": model.name,
      "eatType": model.type,
//      "eatTypeId": model.typeId,
      "dateTime": model.dateTime.toIso8601String(),
      "plan": toJsonDailyFoodPlan(model.plan),
//      "kCal": model.plan.kCal,
//      "imc": model.plan.imc,
      "foods": model.foods.map((f) => toJsonFoodModel(f)).toList()
    };
  }

  @override
  FoodModel fromJsonFoodModel(Map<String, dynamic> json,
      {bool fromAPI = true}) {
    return FoodModel(
        id: json["id"],
        name: json["name"],
        isProteic: json.containsKey("isProteic") ? json["isProteic"] : false,
        isCaloric: json.containsKey("isCaloric") ? json["isCaloric"] : false,
        isFruitAndVegetables: json.containsKey("isFruitAndVegetables")
            ? json["isFruitAndVegetables"]
            : false,
        calories: json["calories"],
        carbohydrates: json["carbohydrates"],
        proteins: json["proteins"],
        fat: json["fat"],
        fiber: json["fiber"],
        image: json["image"],
        count: json.containsKey("count") ? json["count"] : 1,
        children: (fromAPI
                ? (json.containsKey("dishCompoundDishResponse")
                    ? (json["dishCompoundDishResponse"] as List<dynamic>)
                    : [])
                : (json["children"] as List<dynamic>))
            .map((f) =>
                fromAPI ? fromJsonFoodModelWithQTY(f) : fromJsonFoodModel(f))
            .toList(),
        imageMimeType:
            json.containsKey("imageMimeType") ? json["imageMimeType"] : "",
        tags: json.containsKey("tags")
            ? (json['tags'] as List<dynamic>)
                .map((model) => fromJsonFoodTagModel(model))
                .toList()
            : []);
  }

  @override
  Map<String, dynamic> toJsonFoodModel(FoodModel model) {
    return {
      "id": model.id,
      "name": model.name,
      "isProteic": model.isProteic ?? false,
      "isCaloric": model.isCaloric ?? false,
      "isFruitAndVegetables": model.isFruitAndVegetables ?? false,
      "calories": model.calories,
      "carbohydrates": model.carbohydrates,
      "proteins": model.proteins,
      "image": model.image,
      "imageMimeType": model.imageMimeType ?? "",
      "fat": model.fat,
      "fiber": model.fiber,
      "count": model.count,
      "children":
          model?.children?.map((f) => toJsonFoodModel(f))?.toList() ?? [],
      "tags":
          model?.tags?.map((model) => toJsonFoodModelTag(model))?.toList() ?? []
    };
  }

  @override
  TagModel fromJsonFoodTagModel(Map<String, dynamic> json) {
    return TagModel(id: json["id"], name: json["name"]);
  }

  @override
  Map<String, dynamic> toJsonFoodModelTag(TagModel model) {
    return {"id": model.id, "name": model.name};
  }

  @override
  Map<String, dynamic> toJsonCreateDailyActivityModel(
      CreateDailyActivityModel model) {
    return {
      "eatType": model.id,
      "dishes": model.foods.map((f) => toJsonCreateFoodModel(f)).toList(),
      "compoundDishes":
          model.foodsCompound.map((f) => toJsonCreateFoodModel(f)).toList()
    };
  }

  @override
  Map<String, dynamic> toJsonCreateDailyPlanModel(CreateDailyPlanModel model) {
    return {
      "dateInUtc": model.dateTime.toUtc().toIso8601String(),
      "dateTimeInUserLocalTime": model.dateTime.toIso8601String(),
      "isBalanced": model.isBalanced,
      "eats": model.activities
          .map((m) => toJsonCreateDailyActivityModel(m))
          .toList()
    };
  }

  @override
  Map<String, dynamic> toJsonCreateFoodModel(CreateFoodModel model) {
    return {"dishId": model.id, "qty": model.quantity};
  }

//  @override
//  FoodModel fromJsonCompoundFoodModel(Map<String, dynamic> json) {
//    return FoodModel(
//        id: json["id"],
//        name: json["name"],
//        isProteic: json["isProteic"],
//        isCaloric: json["isCaloric"],
//        isFruitAndVegetables: json["isFruitAndVegetables"],
//        calories: json["calories"],
//        carbohydrates: json["carbohydrates"],
//        proteins: json["proteins"],
//        fat: json["fat"],
//        fiber: json["fiber"],
//        image: json["image"],
//        count: json.containsKey("count") ? json["count"] : 1,
//        imageMimeType: json["imageMimeType"],
//        children: (json["dishCompoundDishResponse"] as List<dynamic>)
//            .map((model) => fromJsonFoodModelWithQTY(model))
//            .toList());
//  }

  @override
  Map<String, dynamic> toJsonCreateCompoundFoodModel(
      CreateFoodCompoundModel model) {
    return {
      "name": model.name,
      "image": model.image,
      "dishes":
          jsonEncode(model.foods.map((f) => toJsonCreateFoodModel(f)).toList())
    };
  }

//  @override
//  PlanFoodParameterModel fromJsonPlanFoodParameter(Map<String, dynamic> json) {
//    PlanFoodParameterModel model = PlanFoodParameterModel(
//        kCalOffSetVal: json["kCalOffSetVal"],
//        kCalMin: json["kCalMin"],
//        kCalMax: json["kCalMax"],
//        breakFastCalVal: json["breakFastCalVal"],
//        breakFastCalValExtra: json["breakFastCalValExtra"],
//        snack1CalVal: json["snack1CalVal"],
//        snack1CalValExtra: json["snack1CalValExtra"],
//        lunchCalVal: json["lunchCalVal"],
//        lunchCalValExtra: json["lunchCalValExtra"],
//        snack2CalVal: json["snack2CalVal"],
//        snack2CalValExtra: json["snack2CalValExtra"],
//        dinnerCalVal: json["dinnerCalVal"],
//        dinnerCalValExtra: json["dinnerCalValExtra"],
//        imc: json["imc"],
//        kCal: json["kcal"],
//        minProteinsPercent: json["minProteinsPercent"],
//        maxProteinsPercent: json["maxProteinsPercent"],
//        minCarbohydratesPercent: json["minCarbohydratesPercent"],
//        maxCarbohydratesPercent: json["maxCarbohydratesPercent"],
//        minFatPercent: json["minFatPercent"],
//        maxFatPercent: json["maxFatPercent"],
//        minFiberPercent: json["minFiberPercent"],
//        maxFiberPercent: json["maxFiberPercent"]);
//    return model;
//  }

//  @override
//  Map<String, dynamic> toJsonPlanFoodParameter(PlanFoodParameterModel model) {
//    final map = {
//      "imc": model.imc,
//      "kcal": model.kCal,
//      "minProteinsPercent": model.minProteinsPercent,
//      "maxProteinsPercent": model.maxProteinsPercent,
//      "minCarbohydratesPercent": model.minCarbohydratesPercent,
//      "maxCarbohydratesPercent": model.maxCarbohydratesPercent,
//      "minFatPercent": model.minFatPercent,
//      "maxFatPercent": model.maxFatPercent,
//      "minFiberPercent": model.minFiberPercent,
//      "maxFiberPercent": model.maxFiberPercent,
//      "kCalOffSetVal": model.kCalOffSetVal,
//      "kCalMin": model.kCalMin,
//      "kCalMax": model.kCalMax,
//      "breakFastCalVal": model.breakFastCalVal,
//      "breakFastCalValExtra": model.breakFastCalValExtra,
//      "snack1CalVal": model.snack1CalVal,
//      "snack1CalValExtra": model.snack1CalValExtra,
//      "lunchCalVal": model.lunchCalVal,
//      "lunchCalValExtra": model.lunchCalValExtra,
//      "snack2CalVal": model.snack2CalVal,
//      "snack2CalValExtra": model.snack2CalValExtra,
//      "dinnerCalVal": model.dinnerCalVal,
//      "dinnerCalValExtra": model.dinnerCalValExtra
//    };
//    return map;
//  }

  @override
  DailyActivityFoodModelAPI fromJsonDailyActivityFoodModelAPI(
      Map<String, dynamic> json) {
    DailyActivityFoodModelAPI model = DailyActivityFoodModelAPI(
      dailyActivitiesFoodModels: (json['result'] as List<dynamic>)
          .map((model) => fromJsonDailyActivityFoodModel(model))
          .toList(),
      planSummaries: (json['planSummaries'] as List<dynamic>)
          .map((model) => fromJsonPlanSummariesAPI(model))
          .toList(),
    );
    return model;
  }

  @override
  PlanSummariesAPI fromJsonPlanSummariesAPI(Map<String, dynamic> json) {
    PlanSummariesAPI model = PlanSummariesAPI(
        dateTime: DateTime.parse(json["planDateTime"]).toLocal(),
        dailyFoodPlanModel:
        fromJsonDailyFoodPlan(json["userEatHealtParameters"]));
    return model;
  }

  @override
  DailyFoodPlanModel fromJsonDailyFoodPlan(Map<String, dynamic> json) {
    DailyFoodPlanModel model = DailyFoodPlanModel(
        kCalOffSetVal: json["kCalOffSetVal"],
        kCalMin: json["kCalMin"],
        kCalMax: json["kCalMax"],
        breakFastCalVal: json["breakFastCalVal"],
        breakFastCalValExtra: json["breakFastCalValExtra"],
        snack1CalVal: json["snack1CalVal"],
        snack1CalValExtra: json["snack1CalValExtra"],
        lunchCalVal: json["lunchCalVal"],
        lunchCalValExtra: json["lunchCalValExtra"],
        snack2CalVal: json["snack2CalVal"],
        snack2CalValExtra: json["snack2CalValExtra"],
        dinnerCalVal: json["dinnerCalVal"],
        dinnerCalValExtra: json["dinnerCalValExtra"],
        imc: json["imc"],
        kCal: json["kcal"],
        minProteinsPercent: json["minProteinsPercent"],
        maxProteinsPercent: json["maxProteinsPercent"],
        minCarbohydratesPercent: json["minCarbohydratesPercent"],
        maxCarbohydratesPercent: json["maxCarbohydratesPercent"],
        minFatPercent: json["minFatPercent"],
        maxFatPercent: json["maxFatPercent"],
        minFiberPercent: json["minFiberPercent"],
        maxFiberPercent: json["maxFiberPercent"]);
    return model;
  }

  @override
  Map<String, dynamic> toJsonDailyFoodPlan(DailyFoodPlanModel model) {
    final map = {
      "imc": model.imc,
      "kcal": model.kCal,
      "minProteinsPercent": model.minProteinsPercent,
      "maxProteinsPercent": model.maxProteinsPercent,
      "minCarbohydratesPercent": model.minCarbohydratesPercent,
      "maxCarbohydratesPercent": model.maxCarbohydratesPercent,
      "minFatPercent": model.minFatPercent,
      "maxFatPercent": model.maxFatPercent,
      "minFiberPercent": model.minFiberPercent,
      "maxFiberPercent": model.maxFiberPercent,
      "kCalOffSetVal": model.kCalOffSetVal,
      "kCalMin": model.kCalMin,
      "kCalMax": model.kCalMax,
      "breakFastCalVal": model.breakFastCalVal,
      "breakFastCalValExtra": model.breakFastCalValExtra,
      "snack1CalVal": model.snack1CalVal,
      "snack1CalValExtra": model.snack1CalValExtra,
      "lunchCalVal": model.lunchCalVal,
      "lunchCalValExtra": model.lunchCalValExtra,
      "snack2CalVal": model.snack2CalVal,
      "snack2CalValExtra": model.snack2CalValExtra,
      "dinnerCalVal": model.dinnerCalVal,
      "dinnerCalValExtra": model.dinnerCalValExtra
    };
    return map;
  }
}
