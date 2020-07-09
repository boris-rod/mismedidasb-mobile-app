import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodDishBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  FoodDishBloC(this._iDishRepository, this._sharedPreferencesManager);

  BehaviorSubject<DailyFoodModel> _dailyFoodController = new BehaviorSubject();

  Stream<DailyFoodModel> get dailyFoodResult => _dailyFoodController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  BehaviorSubject<bool> _showResumeController = new BehaviorSubject();

  Stream<bool> get showResumeResult => _showResumeController.stream;

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<int> _calendarPageController = new BehaviorSubject();

  Stream<int> get calendarPageResult => _calendarPageController.stream;

  BehaviorSubject<DailyFoodModel> _calendarOptionsController =
      new BehaviorSubject();

  Stream<DailyFoodModel> get calendarOptionsResult =>
      _calendarOptionsController.stream;

  BehaviorSubject<DateTime> _copyPlanController = new BehaviorSubject();

  Stream<DateTime> get copyPlanResult => _copyPlanController.stream;

  BehaviorSubject<bool> _nutriInfoHeaderController = new BehaviorSubject();

  Stream<bool> get nutriInfoHeaderResult => _nutriInfoHeaderController.stream;

  BehaviorSubject<bool> _kCalPercentageHideController = new BehaviorSubject();

  Stream<bool> get kCalPercentageHideResult =>
      _kCalPercentageHideController.stream;

//  bool tagsLoaded = false;
//  bool foodsLoaded = false;
  bool showResume = false;
  int currentPage = 0;
  Map<DateTime, DailyFoodModel> dailyFoodModelMap = {};
  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime firstDateHealthResult = DateTime.now();
  bool isCopying = false;
  double imc = 1;
  double kCal = 1;

  void loadInitialData() async {
    ///Pre loading compound foods
    _iDishRepository.getFoodCompoundModelList(forceReload: true);

    dailyFoodModelMap = {};

    firstDate = CalendarUtils.getFirstDateOfPreviousMonth();
    lastDate = CalendarUtils.getLastDateOfNextMonth();

//    tagsLoaded = false;
//    foodsLoaded = false;
    showResume = await _sharedPreferencesManager.getShowDailyResume();
    imc = await _sharedPreferencesManager.getIMC();
    kCal = await _sharedPreferencesManager.getDailyKCal();

    isLoading = true;
    firstDateHealthResult =
        await _sharedPreferencesManager.getFirstDateHealthResult();

    final headerExpanded = await _sharedPreferencesManager
        .getBoolValue(SharedKey.nutriInfoExpanded);
    _nutriInfoHeaderController.sinkAddSafe(headerExpanded);

    final kCalPercentageHide = await _sharedPreferencesManager
        .getBoolValue(SharedKey.kCalPercentageHide);
    _kCalPercentageHideController.sinkAddSafe(kCalPercentageHide);

    await Future.delayed(Duration(milliseconds: 200), () async {
      final resPlans =
          await _iDishRepository.getPlansMergedAPI(firstDate, lastDate);
      if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
        dailyFoodModelMap.addAll(resPlans.value);
      }
      loadDailyPlanData();
    });
    isLoading = false;
  }

  void loadPlansBulks1()async{

  }

  void loadPlansBulks2()async{

  }

  void loadPlansBulks3()async{

  }

  void loadDailyPlanData() {
    final key = dailyFoodModelMap.keys.firstWhere(
        (d) => CalendarUtils.isSameDay(d, selectedDate), orElse: () {
      selectedDate = DateTime.now();
      return dailyFoodModelMap.keys
          .firstWhere((d) => CalendarUtils.isSameDay(d, selectedDate));
    });
    DailyFoodModel daily = dailyFoodModelMap[key];

    _calendarOptionsController.sinkAddSafe(daily);

//    daily.currentCaloriesSum = 0;
//    daily.currentProteinsSum = 0;
//    daily.currentCarbohydratesSum = 0;
//    daily.currentFatSum = 0;
//    daily.currentFiberSum = 0;

//    daily.dailyActivityFoodModelList.forEach((dA) {
//      dA.proteinsDishCalories = 0;
//      dA.fiberDishCalories = 0;
//      dA.carbohydratesDishCalories = 0;

//      final double activityFoodCalories = dA.activityFoodCalories;

//      double car = 0;
//      double fat = 0;
//      double fib = 0;
//      double pro = 0;
//      dA.foods.forEach((f) {
//        car += f.carbohydrates * f.count;
//        fat += f.fat * f.count;
//        fib += f.fiber * f.count;
//        pro += f.proteins * f.count;

//        if (f.tag.id == RemoteConstants.proteins_category_code) {
//          dA.proteinsDishCalories += f.caloriesFixed;
//        } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
//            f.tag.id == RemoteConstants.milk_category_code ||
//            f.tag.id == RemoteConstants.soft_drinks_category_code) {
//          dA.fiberDishCalories += f.caloriesFixed;
//        } else if (f.tag.id == RemoteConstants.fiber_category_code) {
//          dA.carbohydratesDishCalories += f.caloriesFixed;
//        }
//      });

//      dA.proteins = pro * 4;
//      dA.carbohydrates = car * 4;
//      dA.fat = fat * 9;
//      dA.fiber = fib;
//      dA.calories = dA.fat + dA.proteins + dA.carbohydrates;

//      dA.foodsProteinsPercentage =
//          ((dA.proteinsDishCalories > 0 ? dA.proteinsDishCalories : 1) *
//                  100 ~/
//                  activityFoodCalories)
//              .toInt();
//      dA.foodsCarbohydratesPercentage = ((dA.carbohydratesDishCalories > 0
//                  ? dA.carbohydratesDishCalories
//                  : 1) *
//              100 ~/
//              activityFoodCalories)
//          .toInt();
//      dA.foodsFiberPercentage =
//          ((dA.fiberDishCalories > 0 ? dA.fiberDishCalories : 1) *
//                  100 ~/
//                  activityFoodCalories)
//              .toInt();
//
//      daily.currentCaloriesSum += dA.caloriesSum;
//      daily.currentProteinsSum += dA.proteinsSum;
//      daily.currentCarbohydratesSum += dA.carbohydratesSum;
//      daily.currentFatSum += dA.fatSum;
//      daily.currentFiberSum += dA.fiberSum;
//    });

//    CreateDailyPlanModel createPlan = CreateDailyPlanModel.fromDailyFoodModel(daily);
//    print(createPlan.toString());

    _dailyFoodController.sinkAddSafe(daily);
  }

  void setFoodList(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;

//    rootModel.currentCaloriesSum =
//        rootModel.currentCaloriesSum - model.caloriesSum;
//
//    rootModel.currentProteinsSum =
//        rootModel.currentProteinsSum - model.proteinsSum;
//    rootModel.currentCarbohydratesSum =
//        rootModel.currentCarbohydratesSum - model.carbohydratesSum;
//    rootModel.currentFatSum = rootModel.currentFatSum - model.fatSum;
//    rootModel.currentFiberSum = rootModel.currentFiberSum - model.fiberSum;

//    model.proteinsDishCalories = 0;
//    model.fiberDishCalories = 0;
//    model.carbohydratesDishCalories = 0;

//    double car = 0;
//    double fat = 0;
//    double fib = 0;
//    double pro = 0;

//    model.foods.forEach((f) {
//      car += f.carbohydrates * f.count;
//      fat += f.fat * f.count;
//      pro += f.proteins * f.count;
//      fib += f.fiber * f.count;
//
//      if (f.tag.id == RemoteConstants.proteins_category_code) {
//        model.proteinsDishCalories += f.caloriesFixed;
//      } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
//          f.tag.id == RemoteConstants.milk_category_code ||
//          f.tag.id == RemoteConstants.soft_drinks_category_code) {
//        model.carbohydratesDishCalories += f.caloriesFixed;
//      } else if (f.tag.id == RemoteConstants.fiber_category_code) {
//        model.fiberDishCalories += f.caloriesFixed;
//      }
//    });

//    model.proteins = pro * 4;
//    model.carbohydrates = car * 4;
//    model.fat = fat * 9;
//    model.fiber = fib;
//    model.calories = model.fat + model.proteins + model.carbohydrates;

//    final double activityFoodCalories = model.activityFoodCalories;
//    model.foodsProteinsPercentage =
//        (model.proteinsDishCalories * 100 ~/ activityFoodCalories).toInt();
//    model.foodsCarbohydratesPercentage =
//        (model.carbohydratesDishCalories * 100 ~/ activityFoodCalories).toInt();
//    model.foodsFiberPercentage =
//        (model.fiberDishCalories * 100 ~/ activityFoodCalories).toInt();

//    rootModel.currentCaloriesSum += model.caloriesSum;
//    rootModel.currentProteinsSum += model.proteinsSum;
//    rootModel.currentCarbohydratesSum += model.carbohydratesSum;
//    rootModel.currentFatSum += model.fatSum;
//    rootModel.currentFiberSum += model.fiberSum;

    await _iDishRepository.savePlanLocal(rootModel);

//    CreateDailyPlanModel createPlan = CreateDailyPlanModel.fromDailyFoodModel(rootModel);
//    print(createPlan.toString());

    _dailyFoodController.sink.add(rootModel);
  }

  void copyPlan(bool forceCopy, DateTime newSelectedDate) async {
    final rootModel = await dailyFoodResult.first;
    if (rootModel.hasFoods != null) {
      final key = dailyFoodModelMap.keys.firstWhere(
          (d) => CalendarUtils.isSameDay(d, newSelectedDate), orElse: () {
        return null;
      });
      DailyFoodModel daily = dailyFoodModelMap[key];
      if (forceCopy) {
        daily.synced = false;
        daily.dailyActivityFoodModelList[0].foods =
            rootModel.dailyActivityFoodModelList[0].foods;
        daily.dailyActivityFoodModelList[1].foods =
            rootModel.dailyActivityFoodModelList[1].foods;
        daily.dailyActivityFoodModelList[2].foods =
            rootModel.dailyActivityFoodModelList[2].foods;
        daily.dailyActivityFoodModelList[3].foods =
            rootModel.dailyActivityFoodModelList[3].foods;
        daily.dailyActivityFoodModelList[4].foods =
            rootModel.dailyActivityFoodModelList[4].foods;

        await _iDishRepository.savePlanLocal(daily);

        isCopying = true;
        selectedDate = newSelectedDate;
        saveDailyPlan();
      } else if (daily.hasFoods != null) {
        _copyPlanController.sinkAddSafe(newSelectedDate);
      } else {
        daily.synced = false;
        daily.dailyActivityFoodModelList[0].foods =
            rootModel.dailyActivityFoodModelList[0].foods;
        daily.dailyActivityFoodModelList[1].foods =
            rootModel.dailyActivityFoodModelList[1].foods;
        daily.dailyActivityFoodModelList[2].foods =
            rootModel.dailyActivityFoodModelList[2].foods;
        daily.dailyActivityFoodModelList[3].foods =
            rootModel.dailyActivityFoodModelList[3].foods;
        daily.dailyActivityFoodModelList[4].foods =
            rootModel.dailyActivityFoodModelList[4].foods;

        await _iDishRepository.savePlanLocal(daily);

        isCopying = true;
        selectedDate = newSelectedDate;
        saveDailyPlan();
      }
    }
  }

  void saveDailyPlan() async {
    isLoading = true;
    await _sharedPreferencesManager.setShowDailyResume(showResume);

    final dishesRes = await _iDishRepository.syncData();
    if (dishesRes is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap = dishesRes.value;
    } else {
      showErrorMessage(dishesRes);
    }
    loadDailyPlanData();
    isLoading = false;
  }

  void setShowDailyResume(bool value) async {
    _showResumeController.sinkAddSafe(value);
  }

  double getCurrentCaloriesPercentage(DailyFoodModel dailyModel) {
    return dailyModel.currentCaloriesSum *
        100 /
        dailyModel.dailyFoodPlanModel.kCalMax;
  }

  double getCurrentCaloriesPercentageByFood(
      DailyActivityFoodModel dailyActivityFoodModel) {
    return dailyActivityFoodModel.caloriesSum *
        100 /
        (dailyActivityFoodModel.activityFoodCalories +
            dailyActivityFoodModel.activityFoodCaloriesOffSet);
  }

  Color getProgressColor(DailyFoodModel dailyModel) {
    return dailyModel.currentCaloriesSum < dailyModel.dailyFoodPlanModel.kCalMin
        ? Colors.yellowAccent
        : (dailyModel.currentCaloriesSum >=
                    dailyModel.dailyFoodPlanModel.kCalMin &&
                dailyModel.currentCaloriesSum <=
                    dailyModel.dailyFoodPlanModel.kCalMax
            ? Colors.greenAccent
            : Colors.redAccent);
  }

  void changePage(int value) {
    currentPage = value;
    _pageController.sinkAddSafe(currentPage);
  }

  void changeCalendarPage(bool next) async {
//    final currentPage = await calendarPageResult.first;
//    if(next && currentPage < 1){
//      _calendarPageController.sinkAddSafe(currentPage + 1);
//    }
  }

  Map<DateTime, List<DailyFoodModel>> getEvents() {
    Map<DateTime, List<DailyFoodModel>> map = {};
    dailyFoodModelMap.forEach((k, value) {
      map[k] = [value];
    });
    return map;
  }

  void changeNutriInfoHeader(bool value) async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.nutriInfoExpanded, value);
    _nutriInfoHeaderController.sinkAddSafe(value);
  }

  void changeKCalPercentageHide(bool value) async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.kCalPercentageHide, value);
    _kCalPercentageHideController.sinkAddSafe(value);
  }

  bool enableNextMonth(){
    final next = CalendarUtils.getLastDateOfPreviousMonth();
    final val = CalendarUtils.compareByMonth(DateTime.now(), next);
    return val >=0;
  }

  @override
  void dispose() {
    _nutriInfoHeaderController.close();
    _kCalPercentageHideController.close();
    _foodsController.close();
    _dailyFoodController.close();
    _showResumeController.close();
    _calendarPageController.close();
    _calendarOptionsController.close();
    _copyPlanController.close();
    _pageController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }
}
