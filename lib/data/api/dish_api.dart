import 'dart:convert';
import 'dart:io';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class DishApi extends BaseApi implements IDishApi {
  final NetworkHandler _networkHandler;
  final IDishConverter _foodConverter;

  DishApi(this._networkHandler, this._foodConverter);

  @override
  Future<List<FoodModel>> getFoodModelList(
      {String query = "",
      int tag,
      int page = 1,
      int perPage = 100,
      int harvardFilter,
        FoodsTypeMark foodsType = FoodsTypeMark.all}) async {
    final tagsFilterQuery = tag >= 0 ? "&tags=$tag" : "";
    final harvardFilterQuery =
        harvardFilter >= 0 ? "&harvardFilter=$harvardFilter" : "";

    final res = await _networkHandler.get(
        path:
            "${foodsType == FoodsTypeMark.lackSelfControl ? Endpoint.add_lack_self_control : foodsType == FoodsTypeMark.favorites ? Endpoint.dish_favorites : Endpoint.dish}?page=$page&perPage=$perPage&search=$query$tagsFilterQuery$harvardFilterQuery");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l.map((model) => _foodConverter.fromJsonFoodModel(model)).toList();
    } else
      throw serverException(res);
  }

  @override
  Future<List<TagModel>> getTagList() async {
    final res = await _networkHandler.get(path: Endpoint.dish_tags);
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l
          .map((model) => _foodConverter.fromJsonFoodTagModel(model))
          .toList();
    } else
      throw serverException(res);
  }

  @override
  Future<List<DailyFoodModel>> getPlansMergedAPI(
      DateTime start, DateTime end) async {
    final res = await _networkHandler.get(
        path: Endpoint.eat_by_date_range,
        params:
            "?date=${start.toIso8601String()}&endDate=${end.toIso8601String()}");
    if (res.statusCode == RemoteConstants.code_success) {
      final json = jsonDecode(res.body);
      final DailyActivityFoodModelAPI model =
          _foodConverter.fromJsonDailyActivityFoodModelAPI(json);
      List<DailyFoodModel> result = [];

      model.planSummaries.forEach((planSummary) {
        //Getting 5 activities associated to planSummary
        final activities = model.dailyActivitiesFoodModels
            .where((activity) => CalendarUtils.isSameDay(
                activity.dateTime, planSummary.dateTime))
            .toList();
        activities.forEach((element) {
          element.dateTime = element.dateTime.toLocal();
        });

        final dailyFoodModel = DailyFoodModel(
          dateTime: planSummary.dateTime.toLocal(),
          dailyActivityFoodModelList: activities,
          dailyFoodPlanModel: planSummary.dailyFoodPlanModel,
        );

        result.add(dailyFoodModel);
      });
      return result;
    } else
      throw serverException(res);
  }

  @override
  Future<bool> saveDailyFoodModel(CreateDailyPlanModel model) async {
    final map = _foodConverter.toJsonCreateDailyPlanModel(model);
    final body = jsonEncode(map);
    final res = await _networkHandler.post(
        path: Endpoint.save_daily_food_plan, body: body);
    if (res.statusCode == RemoteConstants.code_success) return true;
    throw serverException(res);
  }

  @override
  Future<bool> createFoodCompoundModelList(
      CreateFoodCompoundModel model) async {
    final foodsMap = model.foods
        .map((f) => _foodConverter.toJsonCreateFoodModel(f))
        .toList();
    final res = await _networkHandler.uploadMultipartForm(
        path: Endpoint.dish_compound,
        name: model.name,
        dishes: foodsMap,
        file: model.image.isNotEmpty ? File(model.image) : null);
    if (res == RemoteConstants.code_success_created) return true;
    throw serverException(Response("", res));
  }

  @override
  Future<bool> deleteFoodCompoundModelList(int id) async {
    final res = await _networkHandler.post(
      path: "${Endpoint.dish_compound}/delete/$id",
    );
    if (res.statusCode == RemoteConstants.code_success) return true;
    throw serverException(res);
  }

  @override
  Future<List<FoodModel>> getFoodCompoundModelList() async {
    final res = await _networkHandler.get(
      path: Endpoint.dish_compound,
    );
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l.map((model) => _foodConverter.fromJsonFoodModel(model)).toList();
    } else
      throw serverException(res);
  }

  @override
  Future<bool> updateFoodCompoundModelList(
      int id, CreateFoodCompoundModel model) async {
    final foodsMap = model.foods
        .map((f) => _foodConverter.toJsonCreateFoodModel(f))
        .toList();
    final res = await _networkHandler.uploadMultipartForm(
        path: "${Endpoint.dish_compound}/$id/update",
        name: model.name,
        dishes: foodsMap,
        method: 'put',
        file: model.image.isNotEmpty ? File(model.image) : null);
    if (res == RemoteConstants.code_success) return true;
    throw serverException(Response("", res));
  }

  @override
  Future<bool> planDailyFullInfo(DateTime dateTime) async {
    // TODO: implement planDailyFullInfo
    throw UnimplementedError();
  }

  @override
  Future<DailyFoodPlanModel> planDailyParameters() async {
    final res = await _networkHandler.get(
      path: Endpoint.plan_daily_parameters,
    );
    if (res.statusCode == RemoteConstants.code_success) {
      final json = jsonDecode(res.body)[RemoteConstants.result];
      return _foodConverter.fromJsonDailyFoodPlan(json);
    } else
      throw serverException(res);
  }

  @override
  Future<bool> addFoodToFavorites(int foodId) async {
    final res = await _networkHandler.post(
        path: Endpoint.add_food_to_favorites, params: "?dishId=$foodId");
    if (res.statusCode == RemoteConstants.code_success_created) {
      return true;
    } else
      throw serverException(res);
  }

  @override
  Future<bool> removeFoodFromFavorites(int foodId) async {
    final res = await _networkHandler.delete(
        path: Endpoint.remove_food_from_favorites, params: "?dishId=$foodId");
    if (res.statusCode == RemoteConstants.code_success) {
      return true;
    } else
      throw serverException(res);
  }

  @override
  Future<bool> addLackSelfControl(int foodId) async {
    final res = await _networkHandler.post(
        path: Endpoint.add_lack_self_control,
        params: "?DishId=$foodId&Intensity=1");
    if (res.statusCode == RemoteConstants.code_success_created) {
      return true;
    } else
      throw serverException(res);
  }

  @override
  Future<bool> removeLackSelfControl(int foodId) async {
    final res = await _networkHandler.delete(
        path: Endpoint.remove_lack_self_control,
        params: "?DishId=$foodId&Intensity=1");
    if (res.statusCode == RemoteConstants.code_success) {
      return true;
    } else
      throw serverException(res);
  }
}
