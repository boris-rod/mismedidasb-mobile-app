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

  bool tagsLoaded = false;
  bool foodsLoaded = false;
  bool showResume = false;
  int currentPage = 0;
  List<DailyFoodModel> dailyFoodModelList = [];
  Map<DateTime, List<DailyFoodModel>> dailyFoodModelMap;

  double dailyKCal = 1;
  double imc = 1;

  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime firstDateHealthResult = DateTime.now();

  void loadInitialData() async {
    firstDate = CalendarUtils.getFirstDateOfMonthAgo();
    lastDate = CalendarUtils.getLastDateOfMonthLater();
    tagsLoaded = false;
    foodsLoaded = false;
    showResume = await _sharedPreferencesManager.getShowDailyResume();
    isLoading = true;

    dailyKCal = await _sharedPreferencesManager.getDailyKCal();
    imc = await _sharedPreferencesManager.getIMC();
    firstDateHealthResult = await _sharedPreferencesManager.getFirstDateHealthResult();

    dailyFoodModelList = await _iDishRepository.getDailyFoodModelList();
    dailyFoodModelMap = {};
    dailyFoodModelList.forEach((d) {
      dailyFoodModelMap[d.dateTime] = [d];
    });
    loadInitialDailyData();

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

//  Map getDailyFoodModelListAsMap() {
//    final Map<DateTime, List<DailyFoodModel>> map = {};
//    dailyFoodModelList.forEach((d) {
//      map[d.dateTime] = [d];
//    });
//    return map;
//  }

  void loadInitialDailyData() {
//    CalendarUtils.compareByMonth(datetime1, datetime2);

    DailyFoodModel daily = dailyFoodModelList.firstWhere(
        (d) => CalendarUtils.isSameDay(d.dateTime, selectedDate), orElse: () {
      return DailyFoodModel.getDailyFoodModel(dailyKCal, imc, selectedDate);
    });

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

    _dailyFoodController.sink.add(rootModel);
  }

  void setShowDailyResume(bool value) async {
    await _sharedPreferencesManager.setShowDailyResume(value);
    _showResumeController.sinkAddSafe(value);
  }

  void saveDailyPlan() async {
    isLoading = true;
    final rootModel = await dailyFoodResult.first;
    await _iDishRepository.saveDailyFoodModel(rootModel);

    dailyFoodModelMap = {};
    dailyFoodModelList.forEach((d) {
      dailyFoodModelMap[d.dateTime] = [d];
    });

    Future.delayed(Duration(seconds: 2), () {
      isLoading = false;
    });
  }

  void changePage(int value) async {
    currentPage = value;
    _pageController.sinkAddSafe(currentPage);
  }

  @override
  void dispose() {
    _foodsController.close();
    _dailyFoodController.close();
    _showResumeController.close();
    _pageController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }
}
