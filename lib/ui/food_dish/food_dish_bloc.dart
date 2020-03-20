import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodDishBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;
  final IPersonalDataRepository _iPersonalDataRepository;

  FoodDishBloC(this._iDishRepository, this._iPersonalDataRepository);

  BehaviorSubject<DailyFoodModel> _dailyFoodController = new BehaviorSubject();

  Stream<DailyFoodModel> get dailyFoodResult => _dailyFoodController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  void loadInitialData() async {
    isLoading = true;

    final healthResult = await _iPersonalDataRepository.getHealthResult();

    final daily = await _iDishRepository.getDailyFoodModel(healthResult);

    daily.currentCaloriesSum = 0;
    daily.currentSumProteins = 0;
    daily.currentSumCarbohydrates = 0;
    daily.currentSumFat = 0;
    daily.currentSumFiber = 0;

    daily.dailyActivityFoodModel.forEach((dA) {
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

    final res = await _iDishRepository.getFoodModelList(forceReload: true);
    if (res is ResultSuccess<List<FoodModel>>) {
//      _foodsController.sink.add(res.value);
    } else {
      showErrorMessage(res);
    }

    final tags = await _iDishRepository.getTagList(forceReload: true);
    if (tags is ResultSuccess<List<TagModel>>) {
    } else {
      showErrorMessage(tags);
    }

    isLoading = false;
  }

  double getCurrentCaloriesPercentage(DailyFoodModel dailyModel) {
    return dailyModel.currentCaloriesSum *
        100 /
        dailyModel.dailyFoodPlanModel.kCalMax;
  }

  double getActivityFoodCalories(
      DailyActivityFoodModel dailyActivityFoodModel) {
    return dailyActivityFoodModel.id == 1
        ? dailyActivityFoodModel.plan.breakFastCalVal
        : (dailyActivityFoodModel.id == 2
            ? dailyActivityFoodModel.plan.snack1CalVal
            : (dailyActivityFoodModel.id == 3
                ? dailyActivityFoodModel.plan.lunchCalVal
                : (dailyActivityFoodModel.id == 4
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
    return dailyActivityFoodModel.id == 1
        ? dailyActivityFoodModel.plan.breakFastCalValExtra
        : (dailyActivityFoodModel.id == 2
            ? dailyActivityFoodModel.plan.snack1CalValExtra
            : (dailyActivityFoodModel.id == 3
                ? dailyActivityFoodModel.plan.lunchCalValExtra
                : (dailyActivityFoodModel.id == 4
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

    await _iDishRepository.saveDailyFoodModel(rootModel);
    _dailyFoodController.sink.add(rootModel);
  }

  @override
  void dispose() {
    _foodsController.close();
    _dailyFoodController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }
}
