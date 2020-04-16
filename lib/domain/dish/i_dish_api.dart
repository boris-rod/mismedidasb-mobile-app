import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishApi {
  Future<List<FoodModel>> getFoodModelList();

  Future<List<TagModel>> getTagList();

  Future<List<DailyActivityFoodModel>> getDailyActivityFoodModelListByDateRange(DateTime start, DateTime end);

  Future<bool> saveDailyFoodModel(CreateDailyPlanModel model);
}
