import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class DishRepository extends BaseRepository implements IDishRepository {
  final IDishApi _dishApi;
  final IDishDao _iDishDao;
  final SharedPreferencesManager _sharedPreferencesManager;

  DishRepository(this._dishApi, this._iDishDao, this._sharedPreferencesManager);

  @override
  Future<bool> savePlanLocal(DailyFoodModel dailyFoodModel) async {
    try {
      List<DailyFoodModel> list = await _iDishDao.getDailyFoodModelList();
      if (list.length >= 100) {
        await _iDishDao.removeDailyFoodModel(
            CalendarUtils.getTimeIdBasedDay(dateTime: list[0].dateTime));
      }
      dailyFoodModel.synced = false;
      await _iDishDao.saveDailyFoodModel(dailyFoodModel);
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<Result<Map<DateTime, DailyFoodModel>>> getPlansMergedAPI(
      DateTime start, DateTime end) async {
    try {
      //Get list of daily activities from API
      List<DailyActivityFoodModel> apiList =
          await _dishApi.getPlansMergedAPI(start.toUtc(), end.toUtc());

      //Converting from UTC to Local time
      apiList.map((f) => f.dateTime = f.dateTime.toLocal()).toList();

      Map<String, List<DailyActivityFoodModel>> dailyActivityMap = {};
      //Grouping daily activities by datetime
      apiList.forEach((ac) {
        final dateMapId =
            CalendarUtils.getTimeIdBasedDay(dateTime: ac.dateTime);

        if (dailyActivityMap[dateMapId]?.isNotEmpty == true) {
          dailyActivityMap[dateMapId].insert(ac.id, ac);
        } else {
          dailyActivityMap[dateMapId] = [ac];
        }
      });

      final List<DailyFoodModel> localList =
          await _iDishDao.getDailyFoodModelList();

      Map<DateTime, DailyFoodModel> resultMap = {};
      Map<String, DailyFoodModel> dailyMap = {};
      DateTime initial = DateTime(start.year, start.month, start.day);

      //Looping over dates from start to end
      while (CalendarUtils.compare(end, initial) >= 0) {
        final dateMapId = CalendarUtils.getTimeIdBasedDay(dateTime: initial);

        //Look for local existence
        final localObj = localList.firstWhere(
            (obj) =>
                CalendarUtils.getTimeIdBasedDay(dateTime: obj.dateTime) ==
                dateMapId, orElse: () {
          return null;
        });

        if (localObj != null) {
          dailyMap[dateMapId] = localObj;
        } else if (dailyActivityMap.containsKey(dateMapId) &&
            dailyActivityMap[dateMapId]?.isNotEmpty == true) {
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              synced: true,
              dailyActivityFoodModelList: dailyActivityMap[dateMapId],
              dailyFoodPlanModel: dailyActivityMap[dateMapId][0].plan);
        } else {
          double kCal = await _sharedPreferencesManager.getDailyKCal();
          double imc = await _sharedPreferencesManager.getIMC();

          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              synced: true,
              dailyActivityFoodModelList:
                  DailyActivityFoodModel.getDailyActivityFoodModelList(
                      DailyFoodPlanModel(dailyKCal: kCal, imc: imc), initial),
              dailyFoodPlanModel:
                  DailyFoodPlanModel(dailyKCal: kCal, imc: imc));
        }
        //Adding daily plan merged
        resultMap[initial] = dailyMap[dateMapId];

        initial = initial.add(Duration(days: 1));
      }

      await _iDishDao.saveDailyFoodModelList(resultMap.values.toList());

      return ResultSuccess(value: resultMap);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<Map<DateTime, DailyFoodModel>>> syncData() async {
    try {
      List<DailyFoodModel> localList = await _iDishDao.getDailyFoodModelList();
      List<DailyFoodModel> notSavedList =
          localList.where((p) => !p.synced).toList();
      List<DailyFoodModel> syncedList = [];

      await Future.forEach<DailyFoodModel>(notSavedList, (obj) async {
        final apiObj = CreateDailyPlanModel.fromDailyFoodModel(obj);
        obj.synced = await _dishApi.saveDailyFoodModel(apiObj);
        if (obj.synced) syncedList.add(obj);
      });

      await _iDishDao.saveDailyFoodModelList(syncedList);

      final newSyncedLocalList = await _iDishDao.getDailyFoodModelList();
      Map<DateTime, DailyFoodModel> map = {};
      newSyncedLocalList.forEach((d) {
        map[d.dateTime] = d;
      });

      return Result.success(value: map);
    } catch (ex) {
      return resultError(ex);
    }
  }

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
//      List<FoodModel> listTemp = [];
//      for(int i = 0; i < 100; i ++){
//        listTemp.add(list[i]);
//      }
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
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
  Future<Result<bool>> createFoodCompoundModelList(
      CreateFoodCompoundModel model) async {
    try {
      final res = await _dishApi.createFoodCompoundModelList(model);
      return Result.success(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> deleteFoodCompoundModelList(int id) async {
    try {
      final res = await _dishApi.deleteFoodCompoundModelList(id);
      return Result.success(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<List<FoodModel>>> getFoodCompoundModelList() async {
    try {
      final res = await _dishApi.getFoodCompoundModelList();
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<FoodModel>> updateFoodCompoundModelList(int id, CreateFoodCompoundModel model) async {
    try {
      final res = await _dishApi.updateFoodCompoundModelList(id, model);
      return Result.success(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
