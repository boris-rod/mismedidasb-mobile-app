import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/enums.dart';

abstract class IDishApi {
  Future<List<FoodModel>> getFoodModelList(
      {String query, int tag, int page, int perPage, int harvardFilter, FoodsTypeMark foodsType});

  Future<List<FoodModel>> getFoodCompoundModelList();

  Future<bool> createFoodCompoundModelList(CreateFoodCompoundModel model);

  Future<bool> updateFoodCompoundModelList(
      int id, CreateFoodCompoundModel model);

  Future<bool> deleteFoodCompoundModelList(int id);

  Future<List<TagModel>> getTagList();

  Future<List<DailyFoodModel>> getPlansMergedAPI(
      DateTime start, DateTime end);

  Future<void> getCustomMenus();

  Future<bool> saveDailyFoodModel(CreateDailyPlanModel model);

  Future<DailyFoodPlanModel> planDailyParameters();

  Future<bool> planDailyFullInfo(DateTime dateTime);

  Future<bool> addFoodToFavorites(int foodId);

  Future<bool> removeFoodFromFavorites(int foodId);

  Future<bool> addLackSelfControl(int foodId);

  Future<bool> removeLackSelfControl(int foodId);
}
