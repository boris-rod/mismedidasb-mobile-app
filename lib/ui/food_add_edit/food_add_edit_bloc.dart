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

  FoodModel currentFoodModel;
  List<FoodModel> allFoods = [];

  void init(FoodModel foodModel) async {
    final res = await _iDishRepository.getFoodModelList();
    if (res is ResultSuccess<List<FoodModel>>) allFoods.addAll(res.value);
    if (foodModel == null) {
      currentFoodModel = FoodModel(
        children: [],
      );
    } else {
      currentFoodModel = foodModel;
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

  void addFood() async {
    if (currentFoodModel.children.isEmpty) {
      Fluttertoast.showToast(msg: "Debe adicionar al menos un alimento");
    } else if (currentFoodModel.children.length == 1 &&
        currentFoodModel.children[0].count == 1) {
      Fluttertoast.showToast(
          msg: "El número de porciones debe ser mayor que 1.");
    } else {
      isLoading = true;
      try {
//        final File photo = File(currentFoodModel.image);
//        final ext = photo.path.split(".").last;
//        final root = await FileManager.getRootFilesDir();
//        final File newFile = await photo.copy("$root/food_photo.$ext");
//        final compressedFile =
//            await FileManager.testCompressAndGetFile(photo, newFile.path);
//        currentFoodModel.image = compressedFile.path;

        final res = await _iDishRepository.createFoodCompoundModelList(
            CreateFoodCompoundModel.fromFoodModel(currentFoodModel));
        if (res is ResultSuccess<bool>) {
          _foodController.sinkAddSafe(currentFoodModel);
        } else
          showErrorMessage(res);
      } catch (ex) {

      }
      isLoading = false;
    }
  }

  @override
  void dispose() {
    _foodController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
