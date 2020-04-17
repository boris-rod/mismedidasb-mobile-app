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
        id: json[fromAPI ? "eatTypeId": "id"],
//        name: json["name"],
//        typeId: json["eatTypeId"],
        type: json["eatType"],
        dateTime: fromAPI
            ? DateTime.parse(json["createdAt"]).toLocal()
            : DateTime.parse(json["dateTime"]),
        plan: DailyFoodPlanModel(
            dailyKCal: json[fromAPI ? "kCal" : "dailyKCal"] ?? 1, imc: json["imc"] ?? 1),
        foods: (json[fromAPI ? "eatDishResponse" : "foods"] as List<dynamic>)
            .map((model) => fromAPI
                ? fromJsonFoodModelWithQTY(model)
                : fromJsonFoodModel(model))
            .toList());
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
  FoodModel fromJsonFoodModelWithQTY(Map<String, dynamic> json) {
    return fromJsonFoodModel(json["dish"]);
  }

  @override
  FoodModel fromJsonFoodModel(Map<String, dynamic> json) {
    return FoodModel(
        id: json["id"],
        name: json["name"],
        calories: json["calories"],
        carbohydrates: json["carbohydrates"],
        proteins: json["proteins"],
        fat: json["fat"],
        fiber: json["fiber"],
        image: json["image"],
        imageMimeType: json["imageMimeType"],
        tags: (json['tags'] as List<dynamic>)
            .map((model) => fromJsonFoodTagModel(model))
            .toList());
  }


  @override
  Map<String, dynamic> toJsonFoodModel(FoodModel model) {
    return {
      "id": model.id,
      "name": model.name,
      "calories": model.calories,
      "carbohydrates": model.carbohydrates,
      "proteins": model.proteins,
      "image": model.image,
      "imageMimeType": model.imageMimeType,
      "fat": model.fat,
      "fiber": model.fiber,
      "tags": model.tags.map((model) => toJsonFoodModelTag(model)).toList()
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
      "dishes": model.foods.map((f) => toJsonCreateFoodModel(f)).toList()
    };
  }

  @override
  Map<String, dynamic> toJsonCreateDailyPlanModel(CreateDailyPlanModel model) {
    return {
      "dateInUtc": model.dateTime.toUtc().toIso8601String(),
      "eats": model.activities
          .map((m) => toJsonCreateDailyActivityModel(m))
          .toList()
    };
  }

  @override
  Map<String, dynamic> toJsonCreateFoodModel(CreateFoodModel model) {
    return {"dishId": model.id, "qty": 1};
  }
}
