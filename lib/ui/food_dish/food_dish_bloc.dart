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

    daily.dailyActivityFoodModel.forEach((dA) {
      dA.foodsCarbohydrates?.clear();
      dA.foodsProteins?.clear();
      dA.foodsFiber?.clear();

      dA.foodsProteinsPercentage = 0;
      dA.foodsCarbohydratesPercentage = 0;
      dA.foodsFiberPercentage = 0;

      dA.foodsProteinsCalories = 0;
      dA.foodsCarbohydratesCalories = 0;
      dA.foodsFiberCalories = 0;

      double cal = 0;
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
          if (dA.foodsProteins == null) dA.foodsProteins = [];
          dA.foodsProteins.add(f);
        } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
            f.tag.id == RemoteConstants.milk_category_code ||
            f.tag.id == RemoteConstants.soft_drinks_category_code) {
          if (dA.foodsCarbohydrates == null) dA.foodsCarbohydrates = [];
          dA.foodsCarbohydrates.add(f);
        } else if (f.tag.id == RemoteConstants.fiber_category_code) {
          if (dA.foodsFiber == null) dA.foodsFiber = [];
          dA.foodsFiber.add(f);
        }
      });
      cal = fat * 9 + pro * 4 + car * 4;

      daily.currentCaloriesSum += cal;

      dA.calories = cal;
      dA.proteins = pro;
      dA.carbohydrates = car;
      dA.fat = fat;
      dA.fiber = fib;


      if (dA.foodsProteins == null) dA.foodsProteins = [];
      dA.foodsProteins.forEach((f) {
        dA.foodsProteinsCalories += f.calories;
      });

      if (dA.foodsCarbohydrates == null) dA.foodsCarbohydrates = [];
      dA.foodsCarbohydrates.forEach((f) {
        dA.foodsCarbohydratesCalories += f.calories;
      });

      if (dA.foodsFiber == null) dA.foodsFiber = [];
      dA.foodsFiber.forEach((f) {
        dA.foodsFiberCalories += f.calories;
      });

      dA.foodsProteinsPercentage =
          (dA.foodsProteinsCalories * 100 ~/ (dA.calories == 0 ? 1 : dA.calories)).toInt();

      dA.foodsCarbohydratesPercentage =
          (dA.foodsCarbohydratesCalories * 100 ~/ (dA.calories == 0 ? 1 : dA.calories)).toInt();

      dA.foodsFiberPercentage =
          (dA.foodsFiberCalories * 100 ~/ (dA.calories == 0 ? 1 : dA.calories)).toInt();
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

//
//  int getCurrentProteins(DailyActivityFoodModel dailyActivityFoodModel) {
//    double proteinCalories = 0.0;
//    if (dailyActivityFoodModel.foodsProteins != null)
//      dailyActivityFoodModel.foodsProteins?.forEach((f) {
//        proteinCalories += f.calories;
//      });
//    final percentage = proteinCalories *
//        100 /
//        (dailyActivityFoodModel.calories == 0
//            ? 1
//            : dailyActivityFoodModel.calories);
//    return percentage.toInt();
//  }
//
//  int getCurrentCarbohydrates(DailyActivityFoodModel dailyActivityFoodModel) {
//    double carbohydratesCalories = 0.0;
//
//    if (dailyActivityFoodModel.foodsProteins != null)
//      dailyActivityFoodModel.foodsProteins.forEach((f) {
//        carbohydratesCalories += f.calories;
//      });
//    final percentage = carbohydratesCalories *
//        100 /
//        (dailyActivityFoodModel.calories == 0
//            ? 1
//            : dailyActivityFoodModel.calories);
//    return percentage.toInt();
//  }
//
//  int getCurrentFiber(DailyActivityFoodModel dailyActivityFoodModel) {
//    double fiberCalories = 0.0;
//
//    if (dailyActivityFoodModel.foodsProteins != null)
//      dailyActivityFoodModel.foodsProteins.forEach((f) {
//        fiberCalories += f.calories;
//      });
//    final percentage = fiberCalories *
//        100 /
//        (dailyActivityFoodModel.calories == 0
//            ? 1
//            : dailyActivityFoodModel.calories);
//    return percentage.toInt();
//  }

//  void expCollDailyFood(DailyActivityFoodModel model) async {
//    final rootModel = await dailyFoodResult.first;
//    rootModel.dailyActivityFoodModel.forEach((m) {
//      if (model.id == m.id)
//        m.isExpanded = !m.isExpanded;
//      else {
//        m.isExpanded = false;
//      }
//    });
//    _dailyFoodController.sink.add(rootModel);
//  }

  void setFoodList(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;

    rootModel.currentCaloriesSum =
        rootModel.currentCaloriesSum - model.calories;

    model.foodsCarbohydrates?.clear();
    model.foodsProteins?.clear();
    model.foodsFiber?.clear();

    model.foodsProteinsCalories = 0;
    model.foodsCarbohydratesCalories = 0;
    model.foodsFiberCalories = 0;

    model.foodsProteinsPercentage = 0;
    model.foodsCarbohydratesPercentage = 0;
    model.foodsFiberPercentage = 0;

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
        if (model.foodsProteins == null) model.foodsProteins = [];
        model.foodsProteins.add(f);
      } else if (f.tag.id == RemoteConstants.carbohydrate_fat_category_code ||
          f.tag.id == RemoteConstants.milk_category_code ||
          f.tag.id == RemoteConstants.soft_drinks_category_code) {
        if (model.foodsCarbohydrates == null) model.foodsCarbohydrates = [];
        model.foodsCarbohydrates.add(f);
      } else if (f.tag.id == RemoteConstants.fiber_category_code) {
        if (model.foodsFiber == null) model.foodsFiber = [];
        model.foodsFiber.add(f);
      }
    });
    model.carbohydrates = car;
    model.fat = fat;
    model.proteins = pro;
    model.fiber = fib;
    model.calories = fat * 9 + pro * 4 + car * 4;

    rootModel.currentCaloriesSum =
        rootModel.currentCaloriesSum + model.calories;

    if (model.foodsProteins == null) model.foodsProteins = [];
    model.foodsProteins.forEach((f) {
      model.foodsProteinsCalories += f.calories;
    });

    if (model.foodsCarbohydrates == null) model.foodsCarbohydrates = [];
    model.foodsCarbohydrates.forEach((f) {
      model.foodsCarbohydratesCalories += f.calories;
    });

    if (model.foodsFiber == null) model.foodsFiber = [];
    model.foodsFiber.forEach((f) {
      model.foodsFiberCalories += f.calories;
    });

    model.foodsProteinsPercentage =
        (model.foodsProteinsCalories * 100 ~/ (model.calories == 0 ? 1 : model.calories)).toInt();

    model.foodsCarbohydratesPercentage =
        (model.foodsCarbohydratesCalories * 100 ~/ (model.calories == 0 ? 1 : model.calories)).toInt();

    model.foodsFiberPercentage =
        (model.foodsFiberCalories * 100 ~/ (model.calories == 0 ? 1 : model.calories)).toInt();

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
