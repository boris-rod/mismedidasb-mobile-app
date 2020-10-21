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

  BehaviorSubject<Map<DateTime, List<DailyFoodModel>>> _calendarPageController =
      new BehaviorSubject();

  Stream<Map<DateTime, List<DailyFoodModel>>> get calendarPageResult =>
      _calendarPageController.stream;

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

  BehaviorSubject<bool> _showFirstTimePlanController = new BehaviorSubject();

  Stream<bool> get showFirstTimePlanResult =>
      _showFirstTimePlanController.stream;

  BehaviorSubject<bool> _showFirstTimePlanCopyController =
      new BehaviorSubject();

  Stream<bool> get showFirstTimePlanCopyResult =>
      _showFirstTimePlanCopyController.stream;

//  bool tagsLoaded = false;
//  bool foodsLoaded = false;
  bool showResume = false;
  bool showPlaniSuggest = false;
  int currentPage = 0;
  int currentCalendarPage = 0;
  Map<DateTime, DailyFoodModel> dailyFoodModelMap = {};
  DateTime selectedDate = DateTime.now();
//  DateTime firstDate = DateTime.now();
//  DateTime lastDate = DateTime.now();
  DateTime firstDateHealthResult = DateTime.now();
  bool isCopying = false;
  double imc = 1;
  double kCal = 1;

  void launchFirstTimePlan() async {
    final value = await _sharedPreferencesManager
        .getBoolValue(SharedKey.firstTimeInFoodPlan, defValue: true);
    _showFirstTimePlanController.sinkAddSafe(value);
  }

  void setNotFirstTimePlan() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInFoodPlan, false);
    _showFirstTimePlanController.sinkAddSafe(false);
  }

  void launchFirstTimePlanCopy() async {
    final value = await _sharedPreferencesManager
        .getBoolValue(SharedKey.firstTimeInCopyPlan, defValue: true);
    _showFirstTimePlanCopyController.sinkAddSafe(value);
  }

  void setNotFirstTimePlanCopy() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInCopyPlan, false);
    _showFirstTimePlanCopyController.sinkAddSafe(false);
  }

  void loadInitialData() async {
    dailyFoodModelMap = {};

    isLoading = true;
    showResume = await _sharedPreferencesManager.getShowDailyResume();
    showPlaniSuggest = await _sharedPreferencesManager
        .getBoolValue(SharedKey.hasPlaniVirtualAssesor);
    imc = await _sharedPreferencesManager.getIMC();
    kCal = await _sharedPreferencesManager.getDailyKCal();

    firstDateHealthResult =
        await _sharedPreferencesManager.getFirstDateHealthResult();

    final headerExpanded = await _sharedPreferencesManager
        .getBoolValue(SharedKey.nutriInfoExpanded);
    _nutriInfoHeaderController.sinkAddSafe(headerExpanded);

    final kCalPercentageHide = await _sharedPreferencesManager
        .getBoolValue(SharedKey.kCalPercentageHide);
    _kCalPercentageHideController.sinkAddSafe(kCalPercentageHide);

    final now = DateTime.now();
    final resPlans = await _iDishRepository.getPlansMergedAPI(now, now);
    if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap.addAll(resPlans.value);
    }
    loadDailyPlanData();
    isLoading = false;
  }

  void loadDailyPlanData() {
    final key = dailyFoodModelMap.keys.firstWhere(
        (d) => CalendarUtils.isSameDay(d, selectedDate), orElse: () {
      selectedDate = DateTime.now();
      return dailyFoodModelMap.keys
          ?.firstWhere((d) => CalendarUtils.isSameDay(d, selectedDate), orElse: (){return null;});
    });
    DailyFoodModel daily = dailyFoodModelMap[key];

    _calendarOptionsController.sinkAddSafe(daily);
    _dailyFoodController.sinkAddSafe(daily);
  }

  void setFoodList(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;
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

  void changePage(int value) async {
    currentPage = value;
    _pageController.sinkAddSafe(currentPage);
    if (value == 1) {
      changeCalendarPage();
    }
  }

  bool plansBulk1Loaded = false;
  bool plansBulk2Loaded = false;
  bool plansBulk3Loaded = false;

  void changeCalendarPage() async {
    isLoading = true;
    loadPlansBulk1();
    loadPlansBulk2();
    loadPlansBulk3();
  }

  void loadPlansBulk1() async {
    final firstD = CalendarUtils.getFirstDateOfMonth();
    final lastD = CalendarUtils.getLastDateOfMonth();
    final resPlans = await _iDishRepository.getPlansMergedAPI(
      firstD,
      lastD,
    );
    plansBulk1Loaded = true;
    if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap.removeWhere(
          (key, value) => CalendarUtils.compareByMonth(firstD, key) == 0);
      dailyFoodModelMap.addAll(resPlans.value);
      Map<DateTime, List<DailyFoodModel>> map = {};
      dailyFoodModelMap.forEach((key, value) {
        map[key] = [value];
      });
      _calendarPageController.sinkAddSafe(map);
    }
    if (plansBulk2Loaded && plansBulk3Loaded) {
      isLoading = false;
    }
  }

  void loadPlansBulk2() async {
    final firstD = CalendarUtils.getFirstDateOfNextMonth();
    final lastD = CalendarUtils.getLastDateOfNextMonth();
    final resPlans = await _iDishRepository.getPlansMergedAPI(
      firstD,
      lastD,
    );
    plansBulk2Loaded = true;
    if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap.removeWhere(
          (key, value) => CalendarUtils.compareByMonth(firstD, key) == 0);
      dailyFoodModelMap.addAll(resPlans.value);
      Map<DateTime, List<DailyFoodModel>> map = {};
      dailyFoodModelMap.forEach((key, value) {
        map[key] = [value];
      });
      _calendarPageController.sinkAddSafe(map);
    }
    if (plansBulk1Loaded && plansBulk3Loaded) isLoading = false;
  }

  void loadPlansBulk3() async {
    final firstD = CalendarUtils.getFirstDateOfPreviousMonth();
    final lastD = CalendarUtils.getLastDateOfPreviousMonth();
    final resPlans = await _iDishRepository.getPlansMergedAPI(
      firstD,
      lastD,
    );
    plansBulk3Loaded = true;
    if (resPlans is ResultSuccess<Map<DateTime, DailyFoodModel>>) {
      dailyFoodModelMap.removeWhere(
          (key, value) => CalendarUtils.compareByMonth(firstD, key) == 0);
      dailyFoodModelMap.addAll(resPlans.value);
      Map<DateTime, List<DailyFoodModel>> map = {};
      dailyFoodModelMap.forEach((key, value) {
        map[key] = [value];
      });
      _calendarPageController.sinkAddSafe(map);
    }
    if (plansBulk1Loaded && plansBulk2Loaded) isLoading = false;
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

  bool enableNextMonth() {
    final next = CalendarUtils.getLastDateOfPreviousMonth();
    final val = CalendarUtils.compareByMonth(DateTime.now(), next);
    return val >= 0;
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
    _showFirstTimePlanController.close();
    _showFirstTimePlanCopyController.close();
    _copyPlanController.close();
    _pageController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }
}
