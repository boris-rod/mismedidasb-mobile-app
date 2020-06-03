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

  List<FoodModel> allFoods = [];
  String currentQuery = "";

  void init(List<FoodModel> foods) async {
    if (foods.isEmpty) {
      final res = await _iDishRepository.getFoodModelList();
      if (res is ResultSuccess<List<FoodModel>>) allFoods.addAll(res.value);
    } else {
      allFoods.addAll(foods);
    }
    allFoods.sort((a, b) =>
        a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
    _searchController.sinkAddSafe(allFoods);
  }

  void search(String query) async {
    List<FoodModel> resultListQuery = [];
    List<FoodModel> sortedList = [];
    currentQuery = query;
    if (query.trim().isEmpty) {
      allFoods.sort((a, b) =>
          a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      resultListQuery.addAll(allFoods);
    } else {
      String q = cleanedString(currentQuery);
      allFoods.forEach((f) {
        String food = cleanedString(f.name);

//        food = food.replaceAll(RegExp("[á]"), "a");
//        food = food.replaceAll(RegExp("[é]"), "e");
//        food = food.replaceAll(RegExp("[í]"), "i");
//        food = food.replaceAll(RegExp("[ó]"), "o");
//        food = food.replaceAll(RegExp("[üú]"), "u");
//
//        q = q.replaceAll(RegExp("[á]"), "a");
//        q = q.replaceAll(RegExp("[é]"), "e");
//        q = q.replaceAll(RegExp("[í]"), "i");
//        q = q.replaceAll(RegExp("[ó]"), "o");
//        q = q.replaceAll(RegExp("[üú]"), "u");

        if (food.contains(q)) resultListQuery.add(f);
      });
      Comparator<FoodModel> nameComparator = (value1, value2) => cleanedString(value1.name)
          .split(q)
          .first
          .length
          .compareTo(cleanedString(value2.name).split(q).first.length);
      resultListQuery.sort(nameComparator);
    }
    _searchController.sinkAddSafe(resultListQuery);
  }

  String cleanedString(String value){
    value = value.trim().toLowerCase();
    value = value.replaceAll(RegExp("[á]"), "a");
    value = value.replaceAll(RegExp("[é]"), "e");
    value = value.replaceAll(RegExp("[í]"), "i");
    value = value.replaceAll(RegExp("[ó]"), "o");
    value = value.replaceAll(RegExp("[üú]"), "u");
    return value;
  }

  void setSelectedFood(FoodModel foodModel) async {
    final list = await searchResult.first;
    _searchController.sinkAddSafe(list);
  }

  @override
  void dispose() {
    _searchingController.close();
    _searchController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
