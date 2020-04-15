import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

abstract class IDishRepository {
//  Future<DailyFoodModel> getDailyFoodModel(double dailyKCal, double imc);

  Future<List<DailyFoodModel>> getDailyFoodModelList();

  Future<bool> saveDailyFoodModel(DailyFoodModel dailyFoodModel);

  Future<Result<List<FoodModel>>> getFoodModelList({bool forceReload: false});

  Future<Result<List<TagModel>>> getTagList({bool forceReload: false});

  Future<Result<List<DailyFoodModel>>> getDailyActivityFoodModelListByDateRange(DateTime start, DateTime end);

}
