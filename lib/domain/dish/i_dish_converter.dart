import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishConverter {
  Map<String, dynamic> toJsonDailyFoodModel(DailyFoodModel model);

  Map<String, dynamic> toJsonDailyActivityFoodModel(
      DailyActivityFoodModel model);

  Map<String, dynamic> toJsonFoodModel(FoodModel model);

  Map<String, dynamic> toJsonFoodModelTag(TagModel model);

  DailyFoodModel fromJsonDailyFoodModel(Map<String, dynamic> json);

  DailyActivityFoodModel fromJsonDailyActivityFoodModel(
      Map<String, dynamic> json, {bool fromAPI = true});

  FoodModel fromJsonFoodModel(Map<String, dynamic> json, {bool fromAPI = true});

  FoodModel fromJsonFoodModelWithQTY(Map<String, dynamic> json);

  TagModel fromJsonFoodTagModel(Map<String, dynamic> json);

  Map<String, dynamic> toJsonCreateDailyPlanModel(CreateDailyPlanModel model);

  Map<String, dynamic> toJsonCreateDailyActivityModel(
      CreateDailyActivityModel model);

  Map<String, dynamic> toJsonCreateFoodModel(CreateFoodModel model);

  Map<String, dynamic> toJsonCreateCompoundFoodModel(CreateFoodCompoundModel model);

//  FoodModel fromJsonCompoundFoodModel(Map<String, dynamic> json);

}
