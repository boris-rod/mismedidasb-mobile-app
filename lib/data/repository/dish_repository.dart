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
      List<DailyFoodModel> list = await _iDishDao.getDailyFoodModelList(
          CalendarUtils.getFirstDateOfPreviousMonth(),
          CalendarUtils.getLastDateOfNextMonth());
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
      DateTime start, DateTime end,
      {bool forceReload: false}) async {
    try {
      Map<String, List<DailyActivityFoodModel>> dailyActivityMap = {};
      final List<DailyFoodModel> localList =
          await _iDishDao.getDailyFoodModelList(start, end);
      if (forceReload || localList.isEmpty) {
        //Get list of daily activities from API
        List<DailyActivityFoodModel> apiList =
            await _dishApi.getPlansMergedAPI(start.toUtc(), end.toUtc());
        //Converting from UTC to Local time
        apiList.map((f) => f.dateTime = f.dateTime.toLocal()).toList();
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
      }

      Map<DateTime, DailyFoodModel> resultMap = {};
      Map<String, DailyFoodModel> dailyMap = {};
      DateTime initial = DateTime(start.year, start.month, start.day);

      double kCalLocal = await _sharedPreferencesManager.getDailyKCal();
      double imcLocal = await _sharedPreferencesManager.getIMC();
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
          if(localObj.dailyFoodPlanModel.imc <= 1)
            localObj.dailyFoodPlanModel.imc = imcLocal;
          if(localObj.dailyFoodPlanModel.dailyKCal <= 1)
            localObj.dailyFoodPlanModel.dailyKCal = kCalLocal;
          localObj.dailyActivityFoodModelList.forEach((activity) {
            if(activity.imc <= 1)
              activity.imc = imcLocal;
            if(activity.kCal <= 1)
              activity.kCal = kCalLocal;
            if(activity.plan.imc <= 1)
              activity.plan.imc = imcLocal;
            if(activity.plan.dailyKCal <= 1)
              activity.plan.dailyKCal = kCalLocal;
          });

          dailyMap[dateMapId] = localObj;
        } else if (dailyActivityMap.containsKey(dateMapId) &&
            dailyActivityMap[dateMapId]?.isNotEmpty == true) {
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              synced: true,
              dailyActivityFoodModelList: dailyActivityMap[dateMapId],
              dailyFoodPlanModel: dailyActivityMap[dateMapId][0].plan
                ..imc = dailyActivityMap[dateMapId][0].imc
                ..dailyKCal = dailyActivityMap[dateMapId][0].kCal);
        } else {
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              synced: true,
              dailyActivityFoodModelList:
                  DailyActivityFoodModel.getDailyActivityFoodModelList(
                      DailyFoodPlanModel(dailyKCal: kCalLocal, imc: imcLocal), initial),
              dailyFoodPlanModel:
                  DailyFoodPlanModel(dailyKCal: kCalLocal, imc: imcLocal));
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
      List<DailyFoodModel> localList = await _iDishDao.getDailyFoodModelList(
          CalendarUtils.getFirstDateOfPreviousMonth(),
          CalendarUtils.getLastDateOfNextMonth());
      List<DailyFoodModel> notSavedList =
          localList.where((p) => !p.synced).toList();
      List<DailyFoodModel> syncedList = [];

      await Future.forEach<DailyFoodModel>(notSavedList, (obj) async {
        final apiObj = CreateDailyPlanModel.fromDailyFoodModel(obj);
        obj.synced = await _dishApi.saveDailyFoodModel(apiObj);
        if (obj.synced) syncedList.add(obj);
      });

      await _iDishDao.saveDailyFoodModelList(syncedList);

      final newSyncedLocalList = await _iDishDao.getDailyFoodModelList(
          CalendarUtils.getFirstDateOfPreviousMonth(),
          CalendarUtils.getLastDateOfNextMonth());
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
      {String query,
      int tag,
      int page,
      int perPage,
      int harvardFilter}) async {
    try {
      List<FoodModel> list = await _dishApi.getFoodModelList(
          query: query,
          tag: tag,
          page: page,
          perPage: perPage,
          harvardFilter: harvardFilter);
      return Result.success(value: list);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<List<TagModel>>> getTagList() async {
    try {
      List<TagModel> list = await _dishApi.getTagList();
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
  Future<Result<bool>> updateFoodCompoundModelList(
      int id, CreateFoodCompoundModel model) async {
    try {
      final res = await _dishApi.updateFoodCompoundModelList(id, model);
      return Result.success(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
