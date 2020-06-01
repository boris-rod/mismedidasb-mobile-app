import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishDao {
  Future<List<DailyFoodModel>> getDailyFoodModelList();

  Future<bool> saveDailyFoodModel(DailyFoodModel model);

  Future<bool> saveDailyFoodModelList(List<DailyFoodModel> list);

  Future<bool> removeDailyFoodModel(String id);

  Future<List<FoodModel>> getFoodModeList();

  Future<List<FoodModel>> getFoodCompoundModelList();

  Future<bool> saveFoodCompoundModelList();


  Future<bool> saveFoodModelList(List<FoodModel> list);

  Future<bool> clearFoodModelList();

  Future<List<TagModel>> getFoodTagList();

  Future<bool> saveFoodTagList(List<TagModel> list);

  Future<bool> clearFoodTagList();
}
