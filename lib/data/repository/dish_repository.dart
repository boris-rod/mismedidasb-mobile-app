import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/enums.dart';
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
      final objLocal = list.firstWhere(
          (element) => CalendarUtils.isSameDay(
              element.dateTime, dailyFoodModel.dateTime), orElse: () {
        return null;
      });
      bool synced = false;
//      if (objLocal != null && objLocal.synced) {
//        if (!synced) {
//          final actBreakfastFoods =
//              dailyFoodModel.dailyActivityFoodModelList[0].foods;
//          final objBreakfastFoods =
//              objLocal.dailyActivityFoodModelList[0].foods;
//          final diffACTBreakFastList = actBreakfastFoods
//              .map((e) => e.id)
//              .where((value) =>
//                  !objBreakfastFoods.map((e) => e.id).contains(value))
//              .toList();
//          final diffOBJBreakFastList = objBreakfastFoods
//              .map((e) => e.id)
//              .where((value) =>
//                  !actBreakfastFoods.map((e) => e.id).contains(value))
//              .toList();
//          synced = diffACTBreakFastList.isEmpty && diffOBJBreakFastList.isEmpty;
//        }
//
//        if (synced) {
//          final actSnack1Foods =
//              dailyFoodModel.dailyActivityFoodModelList[1].foods;
//          final objSnack1Foods = objLocal.dailyActivityFoodModelList[1].foods;
//          final diffACTSnack1List = actSnack1Foods
//              .map((e) => e.id)
//              .where(
//                  (value) => !objSnack1Foods.map((e) => e.id).contains(value))
//              .toList();
//          final diffOBJSnack1List = objSnack1Foods
//              .map((e) => e.id)
//              .where(
//                  (value) => !actSnack1Foods.map((e) => e.id).contains(value))
//              .toList();
//          synced = diffACTSnack1List.isEmpty && diffOBJSnack1List.isEmpty;
//        }
//
//        if (synced) {
//          final actLunchFoods =
//              dailyFoodModel.dailyActivityFoodModelList[2].foods;
//          final objLunchFoods = objLocal.dailyActivityFoodModelList[2].foods;
//          final diffACTLunchList = actLunchFoods
//              .map((e) => e.id)
//              .where((value) => !objLunchFoods.map((e) => e.id).contains(value))
//              .toList();
//          final diffOBJLunchList = objLunchFoods
//              .map((e) => e.id)
//              .where((value) => !actLunchFoods.map((e) => e.id).contains(value))
//              .toList();
//          synced = diffACTLunchList.isEmpty && diffOBJLunchList.isEmpty;
//        }
//
//        if (synced) {
//          final actSnack2Foods =
//              dailyFoodModel.dailyActivityFoodModelList[3].foods;
//          final objSnack2Foods = objLocal.dailyActivityFoodModelList[3].foods;
//          final diffACTSnack2List = actSnack2Foods
//              .map((e) => e.id)
//              .where(
//                  (value) => !objSnack2Foods.map((e) => e.id).contains(value))
//              .toList();
//          final diffOBJSnack2List = objSnack2Foods
//              .map((e) => e.id)
//              .where(
//                  (value) => !actSnack2Foods.map((e) => e.id).contains(value))
//              .toList();
//          synced = diffACTSnack2List.isEmpty && diffOBJSnack2List.isEmpty;
//        }
//
//        if (synced) {
//          final actDinnerFoods =
//              dailyFoodModel.dailyActivityFoodModelList[4].foods;
//          final objDinnerFoods = objLocal.dailyActivityFoodModelList[4].foods;
//          final diffACTDinnerList = actDinnerFoods
//              .map((e) => e.id)
//              .where(
//                  (value) => !objDinnerFoods.map((e) => e.id).contains(value))
//              .toList();
//          final diffOBJDinnerList = objDinnerFoods
//              .map((e) => e.id)
//              .where(
//                  (value) => !actDinnerFoods.map((e) => e.id).contains(value))
//              .toList();
//          synced = diffACTDinnerList.isEmpty && diffOBJDinnerList.isEmpty;
//        }
//      }
      dailyFoodModel.synced = synced;
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
//      Map<String, List<DailyActivityFoodModel>> dailyActivityMap = {};

      //Get list of daily food from Local
      final List<DailyFoodModel> localList =
          await _iDishDao.getDailyFoodModelList(start, end);

      //Get list of daily food from API
      List<DailyFoodModel> apiList =
          await _dishApi.getPlansMergedAPI(start.toUtc(), end.toUtc());

      //Converting from UTC to Local time
//      apiList.map((f) => f.dateTime = f.dateTime.toLocal()).toList();

      //Grouping daily activities by datetime
//      apiList.forEach((ac) {
//        final dateMapId =
//            CalendarUtils.getTimeIdBasedDay(dateTime: ac.dateTime);
//
//        if (dailyActivityMap[dateMapId]?.isNotEmpty == true) {
//          dailyActivityMap[dateMapId].insert(ac.id, ac);
//        } else {
//          dailyActivityMap[dateMapId] = [ac];
//        }
//      });

      //Getting initial parameters
      double kCalLocal = await _sharedPreferencesManager.getDailyKCal();
      double imcLocal = await _sharedPreferencesManager.getIMC();
      DailyFoodPlanModel dailyFoodPlanModel =
          await _dishApi.planDailyParameters();
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

        final apiObj = apiList.firstWhere(
            (element) => CalendarUtils.isSameDay(element.dateTime, initial),
            orElse: () {
          return null;
        });

        if(localObj == null && apiObj == null){
          dailyMap[dateMapId] = DailyFoodModel(
              dateTime: initial,
              dailyActivityFoodModelList:
              DailyActivityFoodModel.getDailyActivityFoodModelList(
                  dailyFoodPlanModel, initial),
              dailyFoodPlanModel: dailyFoodPlanModel,
              modifiedAt: DateTime.now()
          );
        }else if(localObj != null && apiObj != null){
          final priorityObj = apiObj.modifiedAt.compareTo(localObj.modifiedAt) >= 0 ? apiObj : localObj;
          priorityObj.dailyActivityFoodModelList.forEach((element) {
            element.plan = apiObj.dailyFoodPlanModel;
          });
          dailyMap[dateMapId] = priorityObj;
        }else{
          if (localObj != null) {
            if (apiObj != null) {
              localObj.dailyActivityFoodModelList.forEach((element) {
                element.plan = apiObj.dailyFoodPlanModel;
              });
            }

            dailyMap[dateMapId] = localObj;
          } else if (apiObj != null) {
            apiObj.dailyActivityFoodModelList.forEach((element) {
              if (element.plan == null) {
                element.plan = dailyFoodPlanModel;
              }
            });
            dailyMap[dateMapId] = apiObj;
          }
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
      int harvardFilter,
        FoodsTypeMark foodsType}) async {
    try {
      List<FoodModel> list = await _dishApi.getFoodModelList(
          query: query,
          tag: tag,
          page: page,
          perPage: perPage,
          harvardFilter: harvardFilter,
          foodsType: foodsType);
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

  @override
  Future<Result<DailyFoodPlanModel>> planDailyParameters() async {
    try {
      final res = await _dishApi.planDailyParameters();
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> addFoodToFavorites(int foodId) async {
    try {
      final res = await _dishApi.addFoodToFavorites(foodId);
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> removeFoodFromFavorites(int foodId) async {
    try {
      final res = await _dishApi.removeFoodFromFavorites(foodId);
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> addLackSelfControl(int foodId) async {
    try {
      final res = await _dishApi.addLackSelfControl(foodId);
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> removeLackSelfControl(int foodId) async {
    try {
      final res = await _dishApi.removeLackSelfControl(foodId);
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
