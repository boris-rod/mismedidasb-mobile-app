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

  BehaviorSubject<DailyFoodPlanModel> _dailyPlanController =
      new BehaviorSubject();

  Stream<DailyFoodPlanModel> get dailyPlanResult => _dailyPlanController.stream;

  HealthResult healthResult;
  DailyFoodPlanModel dailyFoodPlanModel;

  void loadInitialData() async {
    isLoading = true;

    if (healthResult == null)
      healthResult = await _iPersonalDataRepository.getHealthResult();

    if (dailyFoodPlanModel == null)
      dailyFoodPlanModel = DailyFoodPlanModel(
          imc: healthResult.imc,
          dailyKCal: healthResult.kCal,
          dateTime: DateTime.now());

    _dailyPlanController.sinkAddSafe(dailyFoodPlanModel);

    final daily = await _iDishRepository.getDailyFoodModel();
    _dailyFoodController.sink.add(daily);

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
    double cal = 0;
    model.foods.forEach((f) {
      cal += f.calories;
    });
    model.calories = cal;

    double car = 0;
    model.foods.forEach((f) {
      car += f.carbohydrates;
    });
    model.carbohydrates = car;

    double fat = 0;
    model.foods.forEach((f) {
      fat += f.fat;
    });
    model.fat = fat;

    double pro = 0;
    model.foods.forEach((f) {
      pro += f.proteins;
    });
    model.proteins = pro;

    double fib = 0;
    model.foods.forEach((f) {
      fib += f.fiber;
    });
    model.fiber = fib;

    _dailyFoodController.sink.add(rootModel);
  }

  @override
  void dispose() {
    _dailyPlanController.close();
    _foodsController.close();
    _dailyFoodController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }
}
