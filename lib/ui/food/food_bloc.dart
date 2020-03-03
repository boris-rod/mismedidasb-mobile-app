import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;

  FoodBloC(this._iDishRepository);

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  BehaviorSubject<List<TagModel>> _tagsController = new BehaviorSubject();

  Stream<List<TagModel>> get tagsResult => _tagsController.stream;

  BehaviorSubject<bool> _searchShowController = new BehaviorSubject();

  Stream<bool> get searchShowResult => _searchShowController.stream;

  bool isSearching = false;
  List<FoodModel> foodsAll = [];
  List<TagModel> tagsAll = [];
  String currentQuery = "";

  void setShowSearch() async {
    isSearching = !isSearching;
    _searchShowController.sinkAddSafe(isSearching);
    if (!isSearching) {
      currentQuery = "";
      queryData();
    }
  }

  void loadData(List<FoodModel> selectedItems) async {
    isSearching = false;
    isLoading = true;
    await loadTags();
    await loadFoods(selectedItems);
    isLoading = false;
  }

  Future<void> loadFoods(List<FoodModel> selectedItems) async {
    List<FoodModel> list = [];
    final res = await _iDishRepository.getFoodModelList();
    if (res is ResultSuccess<List<FoodModel>>) {
      list.addAll(res.value);
      foodsAll.addAll(list);
      foodsAll.forEach((food) {
        selectedItems.forEach((sFood) {
          if (food.id == sFood.id) food.isSelected = true;
        });
      });
    } else
      showErrorMessage(res);
    _foodsController.sinkAddSafe(list);
  }

  void setSelectedFood(FoodModel foodModel) async {
    final currentFoodList = await foodsResult.first;
    currentFoodList.firstWhere((f) => f.id == foodModel.id).isSelected =
        foodModel.isSelected;
    _foodsController.sinkAddSafe(currentFoodList);
  }

  Future<void> loadTags() async {
    List<TagModel> list = [];
    final res = await _iDishRepository.getTagList();
    if (res is ResultSuccess<List<TagModel>>) {
      res.value.forEach((t) {
        t.isSelected = true;
      });
      list.addAll(res.value);
      tagsAll.addAll(list);
    } else
      showErrorMessage(res);
    _tagsController.sinkAddSafe(list);
  }

  void queryData() async {
    List<FoodModel> resultListQuery = [];
    List<FoodModel> resultListTags = [];

    if (currentQuery.isNotEmpty)
      foodsAll.forEach((f) {
        if (f.name.trim().toLowerCase().contains(currentQuery))
          resultListQuery.add(f);
      });
    else
      resultListQuery.addAll(foodsAll);

    final selectedTags = tagsAll.where((t) => t.isSelected).toList();
    resultListQuery.forEach((f) {
      bool contained = false;
      selectedTags.forEach((t) {
        if (t.id == f.tag.id) contained = true;
      });
      if (contained) resultListTags.add(f);
    });

    _foodsController.sinkAddSafe(resultListTags);
  }

  void setTagState(TagModel tag) async {
    tagsAll.forEach((t) {
      if (tag.id == t.id) t.isSelected = !t.isSelected;
    });
    _tagsController.sinkAddSafe(tagsAll);
    queryData();
  }

  @override
  void dispose() {
    _foodsController.close();
    _tagsController.close();
    _searchShowController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
