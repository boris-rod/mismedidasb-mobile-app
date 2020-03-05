import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
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
      }
      if (list.isEmpty) {
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
  Future<DailyFoodModel> getDailyFoodModel(HealthResult healthResult) async {
    List<DailyFoodModel> list = [];
    try {
      list = await _iDishDao.getDailyFoodModelList();
      DailyFoodModel model = list.isNotEmpty
          ? (CalendarUtils.compare(list.last.dateTime, DateTime.now()) != 0
              ? DailyFoodModel.getDailyFoodModel(healthResult)
              : list.last)
          : DailyFoodModel.getDailyFoodModel(healthResult);

      if (model.dailyFoodPlanModel == null) {
        final plan = DailyFoodPlanModel(
            imc: healthResult.imc, dailyKCal: healthResult.kCal);
        model.dailyFoodPlanModel = DailyFoodPlanModel(
            imc: healthResult.imc, dailyKCal: healthResult.kCal);
        model.dailyActivityFoodModel.forEach((dA) {
          if (dA.plan == null) dA.plan = plan;
        });
      }

      await _iDishDao.saveDailyFoodModel(model);
      return model;
    } catch (ex) {
      return DailyFoodModel.getDailyFoodModel(healthResult);
    }
  }

  @override
  Future<Result<List<TagModel>>> getTagList({bool forceReload: false}) async {
    try {
      List<TagModel> list = [];
      if (!forceReload) {
        list = await _iDishDao.getFoodTagList();
      }
      if (list.isEmpty) {
        list = await _dishApi.getTagList();
        final rem = await _iDishDao.clearFoodTagList();
        final saved = await _iDishDao.saveFoodTagList(list);
      }
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<bool> saveDailyFoodModel(DailyFoodModel dailyFoodModel) async {
    try {
      return await _iDishDao.saveDailyFoodModel(dailyFoodModel);
    } catch (ex) {
      return false;
    }
  }
}
