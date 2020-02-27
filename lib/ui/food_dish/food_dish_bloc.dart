import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';

class FoodDishBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;

  FoodDishBloC(this._iDishRepository);

  BehaviorSubject<DailyFoodModel> _dailyFoodController = new BehaviorSubject();

  Stream<DailyFoodModel> get dailyFoodResult => _dailyFoodController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  void loadInitialData() async {
    isLoading = true;
    final daily = await _iDishRepository.getDailyFoodModel();
    _dailyFoodController.sink.add(daily);

    final res = await _iDishRepository.getFoodModelList(forceReload: true);
    if (res is ResultSuccess<List<FoodModel>>) {
//      _foodsController.sink.add(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  Future<List<FoodModel>> loadFoods(String tag, String query) async {
    List<FoodModel> list = [];
    final res = await _iDishRepository.getFoodModelList();
    if (res is ResultSuccess<List<FoodModel>>) {

      res.value.forEach((ele) {
        list.add(ele);
//        bool isInTags = false;
//        ele.tags.forEach((t) {
//          if (t.name.trim().toLowerCase() == tag) isInTags = true;
//        });
//        if (isInTags &&
//            ele.name
//                .trim()
//                .toLowerCase()
//                .contains(query.trim().toLowerCase())) {
//          list.add(ele);
//        }
      });
    } else {
      showErrorMessage(res);
    }
    return list;
  }

  void showHideFoodsView(bool show) {

  }
  void expCollDailyFood(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;
    rootModel.dailyActivityFoodModel.forEach((m) {
      if (model.id == m.id)
        m.isExpanded = !m.isExpanded;
      else {
        m.isExpanded = false;
      }
    });

    _dailyFoodController.sink.add(rootModel);
  }

  void expCollGroup(int dailyFoodModelIndex, FoodGroupModel model) async {
    final rootModel = await dailyFoodResult.first;
    final dailyModel = rootModel.dailyActivityFoodModel[dailyFoodModelIndex];
    dailyModel.foodGroupList.forEach((g) {
      if (model.id == g.id)
        g.isExpanded = !g.isExpanded;
      else
        g.isExpanded = false;
    });
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
