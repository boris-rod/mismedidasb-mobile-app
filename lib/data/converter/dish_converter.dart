import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';

class DishConverter extends IDishConverter {
  @override
  DailyFoodModel fromJsonDailyFoodModel(Map<String, dynamic> json) {
    return DailyFoodModel(
        dateTime: DateTime.parse(json["datetime"]),
        dailyActivityFoodModel:
            (json['dailyActivityFoodModel'] as List<dynamic>)
                .map((model) => fromJsonDailyActivityFoodModel(model))
                .toList());
  }

  @override
  DailyActivityFoodModel fromJsonDailyActivityFoodModel(
      Map<String, dynamic> json) {
    return DailyActivityFoodModel(
        id: json["id"],
        name: json["name"],
        foods: (json['foods'] as List<dynamic>)
            .map((model) => fromJsonFoodModel(model))
            .toList());
  }

  @override
  FoodModel fromJsonFoodModel(Map<String, dynamic> json) {
    List<TagModel> tags = (json['tags'] as List<dynamic>)
        .map((model) => fromJsonFoodTagModel(model))
        .toList();
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
  TagModel fromJsonFoodTagModel(Map<String, dynamic> json) {
    return TagModel(id: json["id"], name: json["name"]);
  }

  @override
  Map<String, dynamic> toJsonDailyFoodModel(DailyFoodModel model) {
    return {
      "id": model.dateTime.toIso8601String(),
      "dailyActivityFoodModel": model.dailyActivityFoodModel
    };
  }

  @override
  Map<String, dynamic> toJsonDailyActivityFoodModel(
      DailyActivityFoodModel model) {
    return {"id": model.id, "name": model.name, "foods": model.foods};
  }

  @override
  Map<String, dynamic> toJsonFoodModel(FoodModel model) {
    return {
      "id": model.id,
      "name": model.name,
      "calories": model.calories,
      "carbohydrates": model.carbohydrates,
      "proteins": model.proteins,
      "fat": model.fat,
      "fiber": model.fiber,
      "tags": model.tags.map((model) => toJsonFoodModelTag(model)).toList()
    };
  }

  @override
  Map<String, dynamic> toJsonFoodModelTag(TagModel model) {
    return {"id": model.id, "name": model.name};
  }
}
