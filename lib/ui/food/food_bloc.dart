import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../enums.dart';

class FoodBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  FoodBloC(this._iDishRepository, this._sharedPreferencesManager);

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  BehaviorSubject<List<FoodModel>> _foodsSelectedController =
      new BehaviorSubject();

  Stream<List<FoodModel>> get foodsSelectedResult =>
      _foodsSelectedController.stream;

  BehaviorSubject<List<FoodModel>> _foodsCompoundController =
      new BehaviorSubject();

  Stream<List<FoodModel>> get foodsCompoundResult =>
      _foodsCompoundController.stream;

  BehaviorSubject<TagModel> _filterController = new BehaviorSubject();

  Stream<TagModel> get filterResult => _filterController.stream;

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  set changePage(int value) => _pageController.sinkAddSafe(value);

  BehaviorSubject<bool> _showFirstTimeController = new BehaviorSubject();

  Stream<bool> get showFirstTimeResult => _showFirstTimeController.stream;

  List<FoodModel> get compoundsFoods => _foodsCompoundController?.value ?? [];

  List<FoodModel> get foods => _foodsController?.value ?? [];

//  double imc = 1;
  bool kCalPercentageHide = false;

  List<TagModel> harvardFilterList = [];
  List<TagModel> tagList = [];
  Map<int, FoodModel> selectedFoods = {};
  FoodFilterMode foodFilterMode = FoodFilterMode.tags;
  int currentHarvardFilter = -1;
  int currentTag = -1;
  int currentPage = 0;
  int currentPerPage = 100;
  bool isLoadingMore = false;
  bool hasMore = true;
  FoodsTypeMark foodsType = FoodsTypeMark.all;

  void loadData(List<FoodModel> selectedItems, FoodFilterMode foodFilterMode,
      int currentTag, int currentHarvardFilter) async {
    isLoading = true;
    this.currentTag = currentTag;
    this.currentHarvardFilter = currentHarvardFilter;

    selectedItems.forEach((element) {
      element.isSelected = true;
      selectedFoods[element.id] = element;
    });
    _foodsSelectedController.sinkAddSafe(selectedItems);

    this.foodFilterMode = foodFilterMode;
    kCalPercentageHide = await _sharedPreferencesManager
        .getBoolValue(SharedKey.kCalPercentageHide);

    if (foodFilterMode == FoodFilterMode.tags) {
      tagList.add(TagModel(isSelected: true, id: -1, name: R.string.filterAll));
      tagList.add(
          TagModel(isSelected: false, id: -2, name: R.string.filterFavorites));
      tagList.add(TagModel(
          isSelected: false, id: -3, name: R.string.filterLackSelfControl));

      final res = await _iDishRepository.getTagList();
      if (res is ResultSuccess<List<TagModel>>) {
        res.value.forEach((t) {
          t.isSelected = false;
        });
        tagList.addAll(res.value);
      } else {
        showErrorMessage(res);
      }
      _filterController.sinkAddSafe(tagList.firstWhere((f) => f.isSelected));
    } else {
      harvardFilterList.add(
          TagModel(isSelected: false, id: -2, name: R.string.filterFavorites));
      harvardFilterList.add(TagModel(
          isSelected: false, id: -3, name: R.string.filterLackSelfControl));
      harvardFilterList.add(TagModel(
          isSelected: currentHarvardFilter == FoodHealthy.proteic.index,
          id: FoodHealthy.proteic.index,
          name: R.string.proteic));
      harvardFilterList.add(TagModel(
          isSelected: currentHarvardFilter == FoodHealthy.caloric.index,
          id: FoodHealthy.caloric.index,
          name: R.string.caloric));
      harvardFilterList.add(TagModel(
          isSelected: currentHarvardFilter == FoodHealthy.fruitVeg.index,
          id: FoodHealthy.fruitVeg.index,
          name: R.string.fiberAndVegetables));
      _filterController
          .sinkAddSafe(harvardFilterList.firstWhere((f) => f.isSelected));
    }

    loadCompoundFoods(true);
    loadFoods(true);
  }

  Future<void> loadFoods(bool replace) async {
    isLoadingMore = true;
    if (replace) {
      currentPage = 0;
    }

    currentPage += 1;

//    if (!replace)
//      Fluttertoast.showToast(
//          msg: "loading more $currentPage",
//          backgroundColor: R.color.habits_color,
//          textColor: R.color.white_color);

    List<FoodModel> currentFoodsList = _foodsController.value;
    final foodsRes = await _iDishRepository.getFoodModelList(
        page: currentPage,
        perPage: currentPerPage,
        query: "",
        tag: currentTag,
        harvardFilter: currentHarvardFilter,
        foodsType: foodsType);
    isLoading = false;

    if (foodsRes is ResultSuccess<List<FoodModel>>) {
      hasMore = foodsRes.value.length >= currentPerPage;

      if (currentFoodsList == null || currentFoodsList.isEmpty || replace)
        currentFoodsList = foodsRes.value;
      else {
        currentFoodsList.addAll(foodsRes.value);
      }
    }

    if (currentFoodsList != null) {
      currentFoodsList.forEach((element) {
        element.isSelected = selectedFoods[element.id]?.isSelected ?? false;
      });
      _foodsController.sinkAddSafe(currentFoodsList);
    }
    isLoadingMore = false;
  }

  Future<void> loadCompoundFoods(bool forceLoad) async {
    if (forceLoad ||
        _foodsCompoundController.value == null ||
        _foodsCompoundController.value.isEmpty) {
      final foodsCompoundRes =
          await _iDishRepository.getFoodCompoundModelList();
      if (foodsCompoundRes is ResultSuccess<List<FoodModel>>) {
        foodsCompoundRes.value.forEach((element) {
          element.isSelected = selectedFoods[element.id]?.isSelected ?? false;
        });
        _foodsCompoundController.sinkAddSafe(foodsCompoundRes.value);
      }
    } else {
      _foodsCompoundController.value.forEach((element) {
        element.isSelected = selectedFoods[element.id]?.isSelected ?? false;
      });
      _foodsCompoundController.sinkAddSafe(_foodsCompoundController.value);
    }
  }

  void syncFoods(List<FoodModel> newList) {
    newList.forEach((element) {
      selectedFoods[element.id] = element;
    });

    _foodsSelectedController.sinkAddSafe(selectedFoods.values.toList());
    final foods = _foodsController.value ?? [];
    foods.forEach((element) {
      element.isSelected = selectedFoods[element.id]?.isSelected ?? false;
    });
    _foodsController.sinkAddSafe(foods);

//    final compoundFoods = _foodsCompoundController.value ?? [];
//    compoundFoods.forEach((element) {
//      element.isSelected = selectedFoods[element.id]?.isSelected ?? false;
//    });
//    _foodsCompoundController.sinkAddSafe(compoundFoods);
  }

  void setSelectedFood(FoodModel foodModel) async {
    if (foodModel.isCompound) {
      final compoundsFoods = _foodsCompoundController.value ?? [];
      final index =
          compoundsFoods.indexWhere((element) => element.id == foodModel.id);
      compoundsFoods[index].isSelected = foodModel.isSelected;
      _foodsCompoundController.sinkAddSafe(compoundsFoods);
    } else {
      final foods = _foodsController.value ?? [];
      final index = foods.indexWhere((element) => element.id == foodModel.id);
      if (index >= 0) foods[index].isSelected = foodModel.isSelected;
      _foodsController.sinkAddSafe(foods);
    }
    if (foodModel.isSelected)
      selectedFoods[foodModel.id] = foodModel;
    else
      selectedFoods.removeWhere((key, value) => key == foodModel.id);
    _foodsSelectedController.sinkAddSafe(selectedFoods.values.toList());
  }

  void changeCategoryFilter(int filterId) {
    if (this.foodFilterMode == FoodFilterMode.tags) {
      if (filterId == currentTag) return;
      currentTag = filterId;
      tagList.forEach((element) {
        element.isSelected = element.id == filterId;
      });
      _filterController.sinkAddSafe(tagList.firstWhere((f) => f.isSelected));
    } else {
      if (filterId == currentHarvardFilter) return;
      currentHarvardFilter = filterId;
      harvardFilterList.forEach((element) {
        element.isSelected = element.id == filterId;
      });
      _filterController
          .sinkAddSafe(harvardFilterList.firstWhere((f) => f.isSelected));
    }

    isLoading = true;
    foodsType = filterId == -2
        ? FoodsTypeMark.favorites
        : filterId == -3
            ? FoodsTypeMark.lackSelfControl
            : FoodsTypeMark.all;
    loadFoods(true);

//    tagsAll.forEach((t) => t.isSelected = t.id == filterId);
//
//    filterFoodsByTagOrCategory();
//
//    syncFoods();
//    _filterController.sinkAddSafe(tagsAll.firstWhere((f) => f.isSelected));
  }

  void launchFirstTime() async {
    final value = await _sharedPreferencesManager
        .getBoolValue(SharedKey.firstTimeInFoodPortions, defValue: true);
    _showFirstTimeController.sinkAddSafe(value);
  }

  void setNotFirstTime() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInFoodPortions, false);
    _showFirstTimeController.sinkAddSafe(false);
  }

  void markUnMarkFood(
      int foodId, FoodsTypeMark foodsTypeMark, bool mark) async {
    if (_pageController.value == 1) {
      final compoundsList = _foodsCompoundController.value ?? [];
      int compoundIndex =
          compoundsList.indexWhere((element) => element.id == foodId);
      if (compoundIndex >= 0) {
        if (foodsTypeMark == FoodsTypeMark.lackSelfControl) {
          if (mark)
            _iDishRepository.addLackSelfControl(foodId);
          else
            _iDishRepository.removeLackSelfControl(foodId);
          compoundsList[compoundIndex].isLackSelfControlDish = mark;
        } else {
          if (mark)
            _iDishRepository.addFoodToFavorites(foodId);
          else
            _iDishRepository.removeFoodFromFavorites(foodId);

          compoundsList[compoundIndex].isFavorite = mark;
        }
        _foodsCompoundController.sinkAddSafe(compoundsList);
      }
    } else {
      final foodList = _foodsController.value ?? [];
      int foodIndex = foodList.indexWhere((element) => element.id == foodId);
      if (foodIndex >= 0) {
        if (foodsTypeMark == FoodsTypeMark.lackSelfControl) {
          if (mark)
            _iDishRepository.addLackSelfControl(foodId);
          else
            _iDishRepository.removeLackSelfControl(foodId);
          foodList[foodIndex].isLackSelfControlDish = mark;
        } else {
          if (mark)
            _iDishRepository.addFoodToFavorites(foodId);
          else
            _iDishRepository.removeFoodFromFavorites(foodId);

          foodList[foodIndex].isFavorite = mark;
        }
        _foodsController.sinkAddSafe(foodList);
      }
    }
  }

  @override
  void dispose() {
    _foodsCompoundController.close();
    _foodsController.close();
    _foodsSelectedController.close();
    _filterController.close();
    _showFirstTimeController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
