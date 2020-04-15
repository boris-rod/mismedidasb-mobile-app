import 'package:mismedidasb/data/_shared_prefs.dart';
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
  final SharedPreferencesManager _sharedPreferencesManager;

  DishRepository(this._dishApi, this._iDishDao, this._sharedPreferencesManager);

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
        if (list?.isNotEmpty == true) {
          final rem = await _iDishDao.clearFoodModelList();
          final saved = await _iDishDao.saveFoodModelList(list ?? []);
        }
      }
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<List<DailyFoodModel>> getDailyFoodModelList() async {
    try {
      List<DailyFoodModel> list = await _iDishDao.getDailyFoodModelList();
      return list;
    } catch (ex) {
      return [];
    }
  }

//  @override
//  Future<DailyFoodModel> getDailyFoodModel(double dailyKCal, double imc) async {
//    try {
//      List<DailyFoodModel> list = await _iDishDao.getDailyFoodModelList();
//
//      DailyFoodModel model = list.isNotEmpty
//          ? (CalendarUtils.compare(list.last.dateTime, DateTime.now()) != 0
//              ? DailyFoodModel.getDailyFoodModel(dailyKCal, imc)
//              : list.last)
//          : DailyFoodModel.getDailyFoodModel(dailyKCal, imc);
//
//      if (model.dailyFoodPlanModel == null) {
//        final plan = DailyFoodPlanModel(imc: imc, dailyKCal: dailyKCal);
//        model.dailyFoodPlanModel = plan;
//        model.dailyActivityFoodModel.forEach((dA) {
//          if (dA.plan == null) dA.plan = plan;
//        });
//      }
//
//      await _iDishDao.saveDailyFoodModel(model);
//      return model;
//    } catch (ex) {
//      return DailyFoodModel.getDailyFoodModel(dailyKCal, imc);
//    }
//  }

  @override
  Future<Result<List<TagModel>>> getTagList({bool forceReload: false}) async {
    try {
      List<TagModel> list = [];
      if (!forceReload) {
        list = await _iDishDao.getFoodTagList();
      }
      if (list.isEmpty) {
        list = await _dishApi.getTagList();
        if (list?.isNotEmpty == true) {
          final rem = await _iDishDao.clearFoodTagList();
          final saved = await _iDishDao.saveFoodTagList(list);
        }
      }
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<bool> saveDailyFoodModel(DailyFoodModel dailyFoodModel) async {
    try {
      List<DailyFoodModel> list = await _iDishDao.getDailyFoodModelList();
      if (list.length >= 100) {
        await _iDishDao.removeDailyFoodModel(
            CalendarUtils.getTimeIdBasedDay(dateTime: list[0].dateTime));
      }
      await _iDishDao.saveDailyFoodModel(dailyFoodModel);
      final l = await _iDishDao.getDailyFoodModelList();
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<Result<List<DailyFoodModel>>>
      getDailyActivityFoodModelListByDateRange(
          DateTime start, DateTime end) async {
    try {
      double kCal = await _sharedPreferencesManager.getDailyKCal();
      double imc = await _sharedPreferencesManager.getIMC();

      //Obtain list of Eats
      List<DailyActivityFoodModel> list =
          await _dishApi.getDailyActivityFoodModelListByDateRange(start.toUtc(), end.toUtc());

      //Converting UTC to Local time
      list.map((f) => f.dateTime = f.dateTime.toLocal()).toList();

      //Grouping Eats by datetime
      Map<String, List<DailyActivityFoodModel>> dailyActivityMap = {};
      list.forEach((ac) {
        final dateMapId =
            CalendarUtils.getTimeIdBasedDay(dateTime: ac.dateTime);

        if (dailyActivityMap.containsKey(dateMapId) &&
            dailyActivityMap[dateMapId]?.isNotEmpty == true) {
          dailyActivityMap[dateMapId].insert(ac.typeId, ac);
        } else {
          dailyActivityMap[dateMapId] = [ac];
        }
      });

      //Looping over dates from start to end
      Map<String, DailyFoodModel> dailyMap = {};
      DateTime initial = DateTime(start.year, start.month, start.day);
      while (CalendarUtils.compare(end, initial) >= 0) {
        final dateMapId = CalendarUtils.getTimeIdBasedDay(dateTime: initial);

        if (dailyActivityMap.containsKey(dateMapId) &&
            dailyActivityMap[dateMapId]?.isNotEmpty == true) {
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              dailyActivityFoodModelList: dailyActivityMap[dateMapId],
              dailyFoodPlanModel: dailyActivityMap[dateMapId][0].plan);
        } else {
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              dailyActivityFoodModelList:
                  DailyActivityFoodModel.getDailyActivityFoodModelList(
                      DailyFoodPlanModel(dailyKCal: kCal, imc: imc), initial),
              dailyFoodPlanModel: DailyFoodPlanModel(dailyKCal: kCal, imc: imc));
        }
        initial = initial.add(Duration(days: 1));
      }

      await _iDishDao.saveDailyFoodModelList(dailyMap.values.toList());

      return ResultSuccess(value: dailyMap.values.toList());
    } catch (ex) {
      return resultError(ex);
    }
  }
}
