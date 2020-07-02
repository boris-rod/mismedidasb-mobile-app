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

  BehaviorSubject<List<FoodModel>> _foodsFilteredController =
      new BehaviorSubject();

  Stream<List<FoodModel>> get foodsFilteredResult =>
      _foodsFilteredController.stream;

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

  double imc = 1;
  bool kCalPercentageHide = false;

  List<FoodModel> foodsAll = [];
  List<FoodModel> foodsFiltered = [];

  List<FoodModel> foodsCompoundAll = [];

  List<TagModel> tagsAll = [];

  FoodFilterMode foodFilterMode = FoodFilterMode.tags;
  int foodFilterCategoryId = -1;

  bool isSearching = false;
  String currentQuery = "";

  void setShowSearch() async {
//    isSearching = !isSearching;
//    _searchShowController.sinkAddSafe(isSearching);
//    if (!isSearching) {
//      currentQuery = "";
//      queryData();
//    }
  }

  void loadData(List<FoodModel> selectedItems, FoodFilterMode foodFilterMode,
      int foodFilterCategoryIndex) async {
    isLoading = true;
    imc = await _sharedPreferencesManager.getIMC();
    kCalPercentageHide = await _sharedPreferencesManager
        .getBoolValue(SharedKey.kCalPercentageHide);

    this.foodFilterCategoryId = foodFilterCategoryIndex;
    this.foodFilterMode = foodFilterMode;

    await _loadCategoryFilter();

    _filterController.sinkAddSafe(tagsAll.firstWhere((f) => f.isSelected));

    final foodsRes = await _iDishRepository.getFoodModelList();
    if (foodsRes is ResultSuccess<List<FoodModel>>) {
      foodsAll.clear();
      foodsAll.addAll(foodsRes.value);
    }

    final foodsCompoundRes = await _iDishRepository.getFoodCompoundModelList();
    if (foodsCompoundRes is ResultSuccess<List<FoodModel>>) {
      foodsAll.addAll(foodsCompoundRes.value);
    }

    selectedItems.forEach((f) => f.isSelected = true);
    foodsAll.forEach((f) {
      final sF =
          selectedItems.firstWhere((food) => food.id == f.id, orElse: () {
        return null;
      });
      if (sF != null) {
        f.isSelected = sF.isSelected;
        f.count = sF.count;
      }
    });

    syncFoods();
    isLoading = false;
  }

  void syncFoods() {
    getSelectedFoods();
    getFilteredFoods();
    getCompoundFoods();
  }

  void getCompoundFoods() {
    final list = foodsAll.where((f) => f.isCompound).toList();
    list.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
    _foodsCompoundController.sinkAddSafe(list);
  }

  void getSelectedFoods() {
    final list = foodsAll.where((f) => f.isSelected).toList();
    _foodsSelectedController.sinkAddSafe(list);
  }

  void getFilteredFoods() {
    filterFoodsByTagOrCategory();
    _foodsFilteredController.sinkAddSafe(foodsFiltered);
  }

  void filterFoodsByTagOrCategory() {
    foodsFiltered.clear();
    if (foodFilterMode == FoodFilterMode.dish_healthy) {
      if (foodFilterCategoryId == FoodHealthy.proteic.index) {
        final List<FoodModel> proteics =
            foodsAll.where((f) => (f?.isProteic == true) ?? false)?.toList() ??
                [];
        foodsFiltered.addAll(proteics);
      } else if (foodFilterCategoryId == FoodHealthy.caloric.index) {
        final List<FoodModel> calorics =
            foodsAll.where((f) => (f?.isCaloric == true) ?? false)?.toList() ??
                [];
        foodsFiltered.addAll(calorics);
      } else {
        final List<FoodModel> fv = foodsAll
                .where((f) => (f?.isFruitAndVegetables == true) ?? false)
                ?.toList() ??
            [];
        foodsFiltered.addAll(fv);
      }
    } else {
      if (foodFilterCategoryId < 0) {
        foodsFiltered.addAll(foodsAll);
      } else {
        final tag =
            tagsAll.firstWhere((t) => t.id == foodFilterCategoryId, orElse: () {
          return null;
        });
        if (tag?.id != null) {
          final res = foodsAll.where((f) => f?.tag?.id == tag.id).toList();
          foodsFiltered.addAll(res);

          if (foodsFiltered.isEmpty) foodsFiltered.addAll(foodsAll);
        } else {
          foodsFiltered.addAll(foodsAll);
        }
      }
    }
  }

  void setSelectedFoodCompound(FoodModel foodModel) async {
    syncFoods();
  }

  void setSelectedFood(FoodModel foodModel) async {
    syncFoods();
//    final f = foodsSingleNonSelected.firstWhere((f) => f.id == foodModel.id,
//        orElse: () {
//      return null;
//    });
//    if (f != null) {
//      f.isSelected = foodModel.isSelected;
//    } else {
//      foodsSingleNonSelected.add(foodModel);
//    }
//
//    if (foodModel.isSelected) {
//      foodsSelected.add(foodModel);
//    } else {
//      foodsSelected.remove(foodModel);
//    }
//    _foodsSelectedController.add(foodsSelected);
//    _foodsFilteredController.sinkAddSafe(foodsSingleNonSelected);
  }

  Future<void> _loadCategoryFilter() async {
    List<TagModel> list = [];
    if (foodFilterMode == FoodFilterMode.tags) {
      list.add(TagModel(isSelected: true, id: -1, name: R.string.filterAll));

      final res = await _iDishRepository.getTagList();
      if (res is ResultSuccess<List<TagModel>>) {
        res.value.forEach((t) {
          t.isSelected = false;
        });
        list.addAll(res.value);
      } else {
        showErrorMessage(res);
      }
    } else {
      list.add(TagModel(
          isSelected: foodFilterCategoryId == FoodHealthy.fruitVeg.index,
          id: FoodHealthy.fruitVeg.index,
          name: R.string.fiberAndVegetables));
      list.add(TagModel(
          isSelected: foodFilterCategoryId == FoodHealthy.proteic.index,
          id: FoodHealthy.proteic.index,
          name: R.string.proteic));
      list.add(TagModel(
          isSelected: foodFilterCategoryId == FoodHealthy.caloric.index,
          id: FoodHealthy.caloric.index,
          name: R.string.caloric));
    }
    tagsAll.addAll(list);
  }

  void changeCategoryFilter(int filterId) {
    foodFilterCategoryId = filterId;

    tagsAll.forEach((t) => t.isSelected = t.id == filterId);

    filterFoodsByTagOrCategory();

    syncFoods();
    _filterController.sinkAddSafe(tagsAll.firstWhere((f) => f.isSelected));
  }

  @override
  void dispose() {
    _foodsCompoundController.close();
    _foodsFilteredController.close();
    _foodsSelectedController.close();
    _filterController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
