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
    }else{
      allFoods.addAll(foods);
    }
    _searchController.sinkAddSafe(allFoods);
  }

  void search(String query) async {
    List<FoodModel> resultListQuery = [];
    currentQuery = query;
    if (query.trim().isEmpty) {
      resultListQuery.addAll(allFoods);
    } else {
      allFoods.forEach((f) {
        String food = f.name.trim().toLowerCase();
        String q = currentQuery.trim().toLowerCase();

        food = food.replaceAll(RegExp("[á]"), "a");
        food = food.replaceAll(RegExp("[é]"), "e");
        food = food.replaceAll(RegExp("[í]"), "i");
        food = food.replaceAll(RegExp("[ó]"), "o");
        food = food.replaceAll(RegExp("[üú]"), "u");

        if (food.contains(q)) resultListQuery.add(f);
      });
    }
    _searchController.sinkAddSafe(resultListQuery);
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
