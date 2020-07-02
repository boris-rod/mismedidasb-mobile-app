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
        dailyFoodPlanModel: DailyFoodPlanModel(
            dailyKCal: json["dailyKCal"] ?? 1, imc: json["imc"] ?? 1),
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
      "dailyKCal": model.dailyFoodPlanModel.dailyKCal,
      "imc": model.dailyFoodPlanModel.imc,
      "dailyActivityFoodModelList": model.dailyActivityFoodModelList
          .map((d) => toJsonDailyActivityFoodModel(d))
          .toList()
    };
  }

  @override
  DailyActivityFoodModel fromJsonDailyActivityFoodModel(
      Map<String, dynamic> json,
      {bool fromAPI = true}) {
    return DailyActivityFoodModel(
        id: json[fromAPI ? "eatTypeId" : "id"],
//        name: json["name"],
//        typeId: json["eatTypeId"],
        type: json["eatType"],
        imc: json["imc"],
        kCal: json["kCal"],
        dateTime: fromAPI
            ? DateTime.parse(json["createdAt"]).toLocal()
            : DateTime.parse(json["dateTime"]),
        plan: DailyFoodPlanModel(
            dailyKCal: json[fromAPI ? "kCal" : "dailyKCal"] ?? 1,
            imc: json["imc"] ?? 1),
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
      "id": model.id,
//      "name": model.name,
      "eatType": model.type,
//      "eatTypeId": model.typeId,
      "dateTime": model.dateTime.toIso8601String(),
      "dailyKCal": model.plan.dailyKCal,
      "imc": model.plan.imc,
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
      "children": model?.children?.map((f) => toJsonFoodModel(f))?.toList() ?? [],
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
}
