import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class DishRepository extends BaseRepository implements IDishRepository {
  final IDishApi _dishApi;
  final IDishDao _iDishDao;

  DishRepository(this._dishApi, this._iDishDao);

  @override
  Future<Result<List<FoodModel>>> getFoodModelList(
      {bool forceReload: false}) async {
    try {
      List<FoodModel> list = [];
      if (!forceReload) {
        list = await _iDishDao.getFoodModeList();
      } else {
        list = await _dishApi.getFoodModelList();
        final rem = await _iDishDao.clearFoodModelList();
        final saved = await _iDishDao.saveFoodModelList(list);
      }
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<DailyFoodModel> getDailyFoodModel() async {
    List<DailyFoodModel> list = [];
    try {
      list = await _iDishDao.getDailyFoodModelList();
      DailyFoodModel model = list.isNotEmpty
          ? (CalendarUtils.compare(list.last.dateTime, DateTime.now()) != 0
              ? DailyFoodModel.getDailyFoodModel()
              : list.last)
          : DailyFoodModel.getDailyFoodModel();
      await _iDishDao.saveDailyFoodModel(model);
      return model;
    } catch (ex) {
      return DailyFoodModel.getDailyFoodModel();
    }
  }
}
