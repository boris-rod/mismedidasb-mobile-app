import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishRepository {
  Future<DailyFoodModel> getDailyFoodModel();

  Future<Result<List<FoodModel>>> getFoodModelList({bool forceReload: false});
}
