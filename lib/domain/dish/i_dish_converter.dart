import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishConverter {
  Map<String, dynamic> toJsonDailyFoodModel(DailyFoodModel model);

  Map<String, dynamic> toJsonDailyActivityFoodModel(
      DailyActivityFoodModel model);

  Map<String, dynamic> toJsonFoodGroupModel(FoodGroupModel model);

  Map<String, dynamic> toJsonFoodModel(FoodModel model);

  Map<String, dynamic> toJsonFoodModelTag(FoodTagModel model);

  DailyFoodModel fromJsonDailyFoodModel(Map<String, dynamic> json);

  DailyActivityFoodModel fromJsonDailyActivityFoodModel(
      Map<String, dynamic> json);

  FoodGroupModel fromJsonFoodGroupModel(Map<String, dynamic> json);

  FoodModel fromJsonFoodModel(Map<String, dynamic> json);

  FoodTagModel fromJsonFoodTagModel(Map<String, dynamic> json);
}
