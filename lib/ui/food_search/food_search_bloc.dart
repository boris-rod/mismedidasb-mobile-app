import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodSearchBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;

  FoodSearchBloC(this._iDishRepository);

  BehaviorSubject<List<FoodModel>> _searchController = new BehaviorSubject();

  Stream<List<FoodModel>> get searchResult => _searchController.stream;

  BehaviorSubject<bool> _searchingController = new BehaviorSubject();

  Stream<bool> get searchingResult => _searchingController.stream;

  set setSearching(value) => _searchingController.sinkAddSafe(value);

  Map<int, FoodModel> selectedFoods = {};
  String currentQuery = "";
  int currentPage = 1;
  int currentPerPage = 100;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isFirstLoad = true;

  void init(List<FoodModel> selectedItems) async {
    selectedItems.forEach((element) {
      selectedFoods[element.id] = element;
    });

    isLoading = true;
    loadFoods(true, true);
  }

  void loadFoods(bool replace, bool showLoading) async {
    if(showLoading)
      isLoading = true;
    isLoadingMore = true;
    currentPage = replace ? 0 : currentPage + 1;

    String query = currentQuery;

    final foodsRes = await _iDishRepository.getFoodModelList(
        page: currentPage + 1,
        perPage: currentPerPage,
        query: currentQuery,
        tag: -1,
        harvardFilter: -1);

    if (foodsRes is ResultSuccess<List<FoodModel>> && query == currentQuery) {
      hasMore = foodsRes.value.length >= currentPerPage;

      List<FoodModel> currentList = _searchController.value ?? [];
      if (replace)
        currentList = foodsRes.value;
      else
        currentList.addAll(foodsRes.value);

      currentList.removeWhere((element) => selectedFoods[element.id]  != null);
      _searchController.sinkAddSafe(currentList);
    }
    isLoading = false;
    isLoadingMore = false;
  }

//  void search(String query) async {
//    List<FoodModel> resultListQuery = [];
//    currentQuery = query;
//    if (query.trim().isEmpty) {
//      resultListQuery.addAll(allFoods);
//    } else {
//      String q = cleanedString(currentQuery);
//      allFoods.forEach((f) {
//        String food = cleanedString(f.name);
//
//        if (food.contains(q)) resultListQuery.add(f);
//      });
//      Comparator<FoodModel> nameComparator = (value1, value2) =>
//          cleanedString(value1.name)
//              .split(q)
//              .first
//              .length
//              .compareTo(cleanedString(value2.name).split(q).first.length);
//      resultListQuery.sort(nameComparator);
//    }
//    _searchController.sinkAddSafe(resultListQuery);
//  }

//  String cleanedString(String value) {
//    value = value.trim().toLowerCase();
//    value = value.replaceAll(RegExp("[á]"), "a");
//    value = value.replaceAll(RegExp("[é]"), "e");
//    value = value.replaceAll(RegExp("[í]"), "i");
//    value = value.replaceAll(RegExp("[ó]"), "o");
//    value = value.replaceAll(RegExp("[üú]"), "u");
//    return value;
//  }

  void setSelectedFood(FoodModel foodModel) async {
    final list = _searchController.value ?? [];
    final index = list.indexWhere((element) => element.id == foodModel.id);
    list[index].isSelected = foodModel.isSelected;
    _searchController.sinkAddSafe(list);

    if (foodModel.isSelected)
      selectedFoods[foodModel.id] = foodModel;
    else
      selectedFoods.removeWhere((key, value) => key == foodModel.id);

  }

  @override
  void dispose() {
    _searchingController.close();
    _searchController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
