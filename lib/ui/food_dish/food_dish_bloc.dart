import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodDishBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;
  final IPersonalDataRepository _iPersonalDataRepository;

  FoodDishBloC(this._iDishRepository, this._iPersonalDataRepository);

  BehaviorSubject<DailyFoodModel> _dailyFoodController = new BehaviorSubject();

  Stream<DailyFoodModel> get dailyFoodResult => _dailyFoodController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController = new BehaviorSubject();

  Stream<List<FoodModel>> get foodsResult => _foodsController.stream;

  void loadInitialData() async {
    isLoading = true;

    final healthResult = await _iPersonalDataRepository.getHealthResult();

    final daily = await _iDishRepository.getDailyFoodModel(healthResult);

    daily.dailyActivityFoodModel.forEach((dA) {
      double cal = 0;
      double car = 0;
      double fat = 0;
      double fib = 0;
      double pro = 0;
      dA.foods.forEach((f) {
        car += f.carbohydrates;
        fat += f.fat;
        fib += f.fiber;
        pro += f.proteins;
      });
      cal = fat * 9 + pro * 4 + car * 4;

      dA.calories = cal;
      dA.proteins = pro;
      dA.carbohydrates = car;
      dA.fat = fat;
      dA.fiber = fib;
    });
    _dailyFoodController.sinkAddSafe(daily);

    final res = await _iDishRepository.getFoodModelList(forceReload: true);
    if (res is ResultSuccess<List<FoodModel>>) {
//      _foodsController.sink.add(res.value);
    } else {
      showErrorMessage(res);
    }

    final tags = await _iDishRepository.getTagList(forceReload: true);
    if (tags is ResultSuccess<List<TagModel>>) {
    } else {
      showErrorMessage(tags);
    }

    isLoading = false;
  }

//  void expCollDailyFood(DailyActivityFoodModel model) async {
//    final rootModel = await dailyFoodResult.first;
//    rootModel.dailyActivityFoodModel.forEach((m) {
//      if (model.id == m.id)
//        m.isExpanded = !m.isExpanded;
//      else {
//        m.isExpanded = false;
//      }
//    });
//    _dailyFoodController.sink.add(rootModel);
//  }

  void setFoodList(DailyActivityFoodModel model) async {
    final rootModel = await dailyFoodResult.first;
    double car = 0;
    double fat = 0;
    double fib = 0;
    double pro = 0;

    model.foods.forEach((f) {
      car += f.carbohydrates;
      fat += f.fat;
      pro += f.proteins;
      fib += f.fiber;
    });
    model.carbohydrates = car;
    model.fat = fat;
    model.proteins = pro;
    model.fiber = fib;
    model.calories = fat * 9 + pro * 4 + car * 4;

    await _iDishRepository.saveDailyFoodModel(rootModel);
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
