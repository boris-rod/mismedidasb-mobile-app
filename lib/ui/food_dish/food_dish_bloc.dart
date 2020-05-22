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

  bool tagsLoaded = false;
  bool foodsLoaded = false;
  bool showResume = false;
  int currentPage = 0;
  Map<DateTime, DailyFoodModel> dailyFoodModelMap = {};
  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime firstDateHealthResult = DateTime.now();
  bool isCopying = false;

  void loadInitialData() async {
    dailyFoodModelMap = {};
    firstDate = CalendarUtils.getFirstDateOfMonthAgo();
    lastDate = CalendarUtils.getLastDateOfMonthLater();
    tagsLoaded = false;
    foodsLoaded = false;
    showResume = await _sharedPreferencesManager.getShowDailyResume();
    isLoading = true;
    firstDateHealthResult =
        await _sharedPreferencesManager.getFirstDateHealthResult();

    final headerExpanded = await _sharedPreferencesManager
        .getBoolValue(SharedKey.nutriInfoExpanded);
    _nutriInfoHeaderController.sinkAddSafe(headerExpanded);

    final kCalPercentageHide = await _sharedPreferencesManager
        .getBoolValue(SharedKey.kCalPercentageHide);
    _kCalPercentageHideController.sinkAddSafe(kCalPercentageHide);

    final resPlans =
        await _iDishRepository.getPlansMergedAPI(firstDate, lastDate);
    if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap = resPlans.value;
    }

    loadDailyPlanData();

    _iDishRepository.getFoodModelList(forceReload: true).then((onValue) {
      foodsLoaded = true;
      if (tagsLoaded) isLoading = false;
    }).catchError((onError) {
      foodsLoaded = true;
      if (tagsLoaded) isLoading = false;
      showErrorMessage(onError);
    });
    _iDishRepository.getTagList(forceReload: true).then((onValue) {
      tagsLoaded = true;
      if (foodsLoaded) isLoading = false;
    }).catchError((onError) {
      tagsLoaded = true;
      if (foodsLoaded) isLoading = false;
      showErrorMessage(onError);
    });
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

    daily.currentCaloriesSum = 0;
    daily.currentSumProteins = 0;
    daily.currentSumCarbohydrates = 0;
    daily.currentSumFat = 0;
    daily.currentSumFiber = 0;

    daily.dailyActivityFoodModelList.forEach((dA) {
      dA.proteinsDishCalories = 0;
      dA.fiberDishCalories = 0;
      dA.carbohydratesDishCalories = 0;

      final double activityFoodCalories = getActivityFoodCalories(dA);

      double car = 0;
      double fat = 0;
      double fib = 0;
      double pro = 0;
      dA.foods.forEach((f) {
        car += f.carbohydrates;
        fat += f.fat;
        fib += f.fiber;
        pro += f.proteins;

        if (f.tag.id == RemoteConstants.proteins_category_code) {
          dA.proteinsDishCalories += f.caloriesFixed;
        } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
            f.tag.id == RemoteConstants.milk_category_code ||
            f.tag.id == RemoteConstants.soft_drinks_category_code) {
          dA.fiberDishCalories += f.caloriesFixed;
        } else if (f.tag.id == RemoteConstants.fiber_category_code) {
          dA.carbohydratesDishCalories += f.caloriesFixed;
        }
      });

      dA.proteins = pro * 4;
      dA.carbohydrates = car * 4;
      dA.fat = fat * 9;
      dA.fiber = fib;
      dA.calories = dA.fat + dA.proteins + dA.carbohydrates;

      dA.foodsProteinsPercentage =
          (dA.proteinsDishCalories * 100 ~/ activityFoodCalories).toInt();
      dA.foodsCarbohydratesPercentage =
          (dA.carbohydratesDishCalories * 100 ~/ activityFoodCalories).toInt();
      dA.foodsFiberPercentage =
          (dA.fiberDishCalories * 100 ~/ activityFoodCalories).toInt();

      daily.currentCaloriesSum += dA.calories;
      daily.currentSumProteins += dA.proteins;
      daily.currentSumCarbohydrates += dA.carbohydrates;
      daily.currentSumFat += dA.fat;
      daily.currentSumFiber += dA.fiber;
    });
    _dailyFoodController.sinkAddSafe(daily);
  }

  void setFoodList(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;

    rootModel.currentCaloriesSum =
        rootModel.currentCaloriesSum - model.calories;

    rootModel.currentSumProteins =
        rootModel.currentSumProteins - model.proteins;
    rootModel.currentSumCarbohydrates =
        rootModel.currentSumCarbohydrates - model.carbohydrates;
    rootModel.currentSumFat = rootModel.currentSumFat - model.fat;
    rootModel.currentSumFiber = rootModel.currentSumFiber - model.fiber;

    model.proteinsDishCalories = 0;
    model.fiberDishCalories = 0;
    model.carbohydratesDishCalories = 0;

    double car = 0;
    double fat = 0;
    double fib = 0;
    double pro = 0;

    model.foods.forEach((f) {
      car += f.carbohydrates;
      fat += f.fat;
      pro += f.proteins;
      fib += f.fiber;

      if (f.tag.id == RemoteConstants.proteins_category_code) {
        model.proteinsDishCalories += f.caloriesFixed;
      } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
          f.tag.id == RemoteConstants.milk_category_code ||
          f.tag.id == RemoteConstants.soft_drinks_category_code) {
        model.carbohydratesDishCalories += f.caloriesFixed;
      } else if (f.tag.id == RemoteConstants.fiber_category_code) {
        model.fiberDishCalories += f.caloriesFixed;
      }
    });

    model.proteins = pro * 4;
    model.carbohydrates = car * 4;
    model.fat = fat * 9;
    model.fiber = fib;
    model.calories = model.fat + model.proteins + model.carbohydrates;

    final double activityFoodCalories = getActivityFoodCalories(model);
    model.foodsProteinsPercentage =
        (model.proteinsDishCalories * 100 ~/ activityFoodCalories).toInt();
    model.foodsCarbohydratesPercentage =
        (model.carbohydratesDishCalories * 100 ~/ activityFoodCalories).toInt();
    model.foodsFiberPercentage =
        (model.fiberDishCalories * 100 ~/ activityFoodCalories).toInt();

    rootModel.currentCaloriesSum += model.calories;
    rootModel.currentSumProteins += model.proteins;
    rootModel.currentSumCarbohydrates += model.carbohydrates;
    rootModel.currentSumFat += model.fat;
    rootModel.currentSumFiber += model.fiber;

    await _iDishRepository.savePlanLocal(rootModel);

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
        loadDailyPlanData();
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
        loadDailyPlanData();
      }
    }
  }

  void saveDailyPlan() async {
    isLoading = true;
    await _sharedPreferencesManager.setShowDailyResume(showResume);

    final dishesRes = await _iDishRepository.syncData();
    if (dishesRes is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap = dishesRes.value;
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

  double getActivityFoodCalories(
      DailyActivityFoodModel dailyActivityFoodModel) {
    return dailyActivityFoodModel.id == 0
        ? dailyActivityFoodModel.plan.breakFastCalVal
        : (dailyActivityFoodModel.id == 1
            ? dailyActivityFoodModel.plan.snack1CalVal
            : (dailyActivityFoodModel.id == 2
                ? dailyActivityFoodModel.plan.lunchCalVal
                : (dailyActivityFoodModel.id == 3
                    ? dailyActivityFoodModel.plan.snack2CalVal
                    : dailyActivityFoodModel.plan.dinnerCalVal)));
  }

  double getCurrentCaloriesPercentageByFood(
      DailyActivityFoodModel dailyActivityFoodModel) {
    return dailyActivityFoodModel.calories *
        100 /
        (getActivityFoodCalories(dailyActivityFoodModel) +
            getActivityFoodCaloriesOffSet(dailyActivityFoodModel));
  }

  double getActivityFoodCaloriesOffSet(
      DailyActivityFoodModel dailyActivityFoodModel) {
    return dailyActivityFoodModel.id == 0
        ? dailyActivityFoodModel.plan.breakFastCalValExtra
        : (dailyActivityFoodModel.id == 1
            ? dailyActivityFoodModel.plan.snack1CalValExtra
            : (dailyActivityFoodModel.id == 2
                ? dailyActivityFoodModel.plan.lunchCalValExtra
                : (dailyActivityFoodModel.id == 3
                    ? dailyActivityFoodModel.plan.snack2CalValExtra
                    : dailyActivityFoodModel.plan.dinnerCalValExtra)));
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
