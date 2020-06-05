import 'dart:convert';
import 'dart:io';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';

class DishApi extends BaseApi implements IDishApi {
  final NetworkHandler _networkHandler;
  final IDishConverter _foodConverter;

  DishApi(this._networkHandler, this._foodConverter);

  @override
  Future<List<FoodModel>> getFoodModelList() async {
    final res = await _networkHandler.get(path: Endpoint.dish);
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
  Future<List<DailyActivityFoodModel>> getPlansMergedAPI(
      DateTime start, DateTime end) async {
    final res = await _networkHandler.get(
        path: Endpoint.eat_by_date_range,
        params:
            "?date=${start.toIso8601String()}&endDate=${end.toIso8601String()}");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l
          .map((model) => _foodConverter.fromJsonDailyActivityFoodModel(model))
          .toList();
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
      return l
          .map((model) => _foodConverter.fromJsonFoodModel(model))
          .toList();
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
}
