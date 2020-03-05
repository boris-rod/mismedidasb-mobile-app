import 'dart:convert';

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
}
