import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishDao {
  Future<List<DailyFoodModel>> getDailyFoodModelList();

  Future<bool> saveDailyFoodModel(DailyFoodModel model);

  Future<List<FoodModel>> getFoodModeList();

  Future<List<TagModel>> getFoodTagList();

  Future<bool> saveFoodTagList(List<TagModel> list);

  Future<bool> saveFoodModelList(List<FoodModel> list);

  Future<bool> clearFoodTagList();

  Future<bool> clearFoodModelList();

  Future<bool> removeDailyFoodModel(String id);
}
