import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodAddEditBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IDishRepository _iDishRepository;

  FoodAddEditBloC(this._iDishRepository);

  BehaviorSubject<FoodModel> _foodController = new BehaviorSubject();

  Stream<FoodModel> get foodResult => _foodController.stream;

  BehaviorSubject<bool> _addEditController = new BehaviorSubject();

  Stream<bool> get addEditResult => _addEditController.stream;

  FoodModel currentFoodModel;
  List<FoodModel> allFoods = [];
  List<FoodModel> currentChildren = [];
  bool reload = false;

  void init(FoodModel foodModel) async {
    final res = await _iDishRepository.getFoodModelList();
    if (res is ResultSuccess<List<FoodModel>>) {
      allFoods.addAll(res.value);
    }
    if (foodModel == null) {
      currentFoodModel = FoodModel(children: [], image: "");
    } else {
      currentFoodModel = foodModel;
      currentChildren.addAll(foodModel.children);
      foodModel.children.forEach((f) => f.isSelected = true);
      allFoods.forEach((f) {
        final sF = foodModel.children.firstWhere((food) => food.id == f.id,
            orElse: () {
              return null;
            });
        if (sF != null) {
          f.isSelected = sF.isSelected;
          f.count = sF.count;
        }
      });
    }
    _foodController.sinkAddSafe(currentFoodModel);
  }

  void updateImage(File file) async {
    currentFoodModel.image = file.path;
    _foodController.sinkAddSafe(currentFoodModel);
  }

  void syncAddedFoods(List<FoodModel> foods) {
    currentFoodModel.children.clear();
    currentFoodModel.children.addAll(foods);
    _foodController.sinkAddSafe(currentFoodModel);
  }

  void remove(FoodModel model) {
    currentFoodModel.children.removeWhere((f) => f.id == model.id);
    final food = allFoods.firstWhere((f) => f.id == model.id, orElse: () {
      return null;
    });
    if (food != null) food.isSelected = false;
    _foodController.sinkAddSafe(currentFoodModel);
  }

  void removeCompoundFood() async {
    isLoading = true;
    final res =
        await _iDishRepository.deleteFoodCompoundModelList(currentFoodModel.id);
    if (res is ResultSuccess<bool>) {
      reload = true;
      _addEditController.sinkAddSafe(true);
    } else {
      showErrorMessage(res);
    }
    reload = true;
    isLoading = false;
  }

  String validateFoodsRules() {
    String rule = "";
    if (currentFoodModel.children.isEmpty) {
      rule = R.string.atLeastOneFood;
      Fluttertoast.showToast(msg: rule);
    } else if (currentFoodModel.children.length == 1 &&
        currentFoodModel.children[0].count == 1) {
      rule = R.string.foodPortionMajorThan1;
      Fluttertoast.showToast(msg: rule);
    }
    return rule;
  }

  void addFood(bool isAdding) async {
    if (validateFoodsRules().isEmpty) {
      isLoading = true;
      try {
        if (isAdding) {
          final res = await _iDishRepository.createFoodCompoundModelList(
              CreateFoodCompoundModel.fromFoodModel(currentFoodModel));
          if (res is ResultSuccess<bool>) {
            reload = true;
            _addEditController.sinkAddSafe(true);
          } else
            showErrorMessage(res);
        } else {
          if (currentFoodModel.image.contains("http"))
            currentFoodModel.image = "";

          final res = await _iDishRepository.updateFoodCompoundModelList(
              currentFoodModel.id,
              CreateFoodCompoundModel.fromFoodModel(currentFoodModel));
          if (res is ResultSuccess<bool>) {
            reload = true;
            _addEditController.sinkAddSafe(true);
          } else
            showErrorMessage(res);
        }
      } catch (ex) {}
      isLoading = false;
    }
  }

  @override
  void dispose() {
    _foodController.close();
    _addEditController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
