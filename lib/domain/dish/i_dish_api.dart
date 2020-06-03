import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishApi {
  Future<List<FoodModel>> getFoodModelList();

  Future<List<FoodModel>> getFoodCompoundModelList();

  Future<bool> createFoodCompoundModelList(CreateFoodCompoundModel model);

  Future<bool> updateFoodCompoundModelList(int id, CreateFoodCompoundModel model);

  Future<bool> deleteFoodCompoundModelList(int id);

  Future<List<TagModel>> getTagList();

  Future<List<DailyActivityFoodModel>> getPlansMergedAPI(
      DateTime start, DateTime end);

  Future<bool> saveDailyFoodModel(CreateDailyPlanModel model);
}
