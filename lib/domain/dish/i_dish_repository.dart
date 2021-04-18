import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

abstract class IDishRepository {
  //Gets local plans, Posts not saved ones against API one by one, update "locallySaved" property to false and save locally
  Future<Result<Map<DateTime, DailyFoodModel>>> syncData();

  //Save plan locally with "locallySaved" property in true
  Future<bool> savePlanLocal(DailyFoodModel dailyFoodModel);

  Future<void> getCustomMenus();

  //Gets plans from API merge with local plans not saved and save local bulk
  Future<Result<Map<DateTime, DailyFoodModel>>> getPlansMergedAPI(
      DateTime start, DateTime end);

  Future<Result<List<FoodModel>>> getFoodModelList(
      {String query, int tag, int page, int perPage, int harvardFilter, FoodsTypeMark foodsType});

  Future<Result<List<FoodModel>>> getFoodCompoundModelList();

  Future<Result<bool>> createFoodCompoundModelList(
      CreateFoodCompoundModel model);

  Future<Result<bool>> updateFoodCompoundModelList(
      int id, CreateFoodCompoundModel model);

  Future<Result<bool>> deleteFoodCompoundModelList(int id);

  Future<Result<List<TagModel>>> getTagList();

  Future<Result<DailyFoodPlanModel>> planDailyParameters();

  Future<Result<bool>> addFoodToFavorites(int foodId);

  Future<Result<bool>> removeFoodFromFavorites(int foodId);

  Future<Result<bool>> addLackSelfControl(int foodId);

  Future<Result<bool>> removeLackSelfControl(int foodId);

}
