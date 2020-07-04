import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishDao {
  Future<List<DailyFoodModel>> getDailyFoodModelList(DateTime start, DateTime end);

  Future<bool> saveDailyFoodModel(DailyFoodModel model);

  Future<bool> saveDailyFoodModelList(List<DailyFoodModel> list);

  Future<bool> removeDailyFoodModel(String id);

  Future<List<FoodModel>> getFoodModeList();

  Future<List<FoodModel>> getFoodCompoundModelList();

  Future<bool> saveFoodCompoundModelList(List<FoodModel> list);

  Future<bool> saveFoodModelList(List<FoodModel> list);

  Future<bool> clearFoodModelList();

  Future<bool> clearFoodCompoundModelList();

  Future<List<TagModel>> getFoodTagList();

  Future<bool> saveFoodTagList(List<TagModel> list);

  Future<bool> clearFoodTagList();
}
