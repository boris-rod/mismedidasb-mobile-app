import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
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
    if (res is ResultSuccess<List<FoodModel>>) allFoods.addAll(res.value);
    if (foodModel == null) {
      currentFoodModel = FoodModel(
        children: [],
      );
    } else {
      currentFoodModel = foodModel;
      currentChildren.addAll(foodModel.children);
    }
    _foodController.sinkAddSafe(currentFoodModel);
  }

  void updateImage(File file) async {
//    final root = await FileManager.getRootFilesDir();
//    final ext = file.path.split(".").last;
//    final File newFile = await file.copy("$root/food_photo.$ext");
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
      Fluttertoast.showToast(msg: "Debe adicionar al menos un alimento");
    } else if (currentFoodModel.children.length == 1 &&
        currentFoodModel.children[0].count == 1) {
      Fluttertoast.showToast(
          msg: "El número de porciones debe ser mayor que 1.");
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
          final res = await _iDishRepository.updateFoodCompoundModelList(
              currentFoodModel.id,
              CreateFoodCompoundModel.fromFoodModel(currentFoodModel));
          if (res is ResultSuccess<FoodModel>) {
            reload = true;
            currentFoodModel = res.value;
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
