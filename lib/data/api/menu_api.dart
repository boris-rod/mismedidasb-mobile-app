
import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/menu/i_menu_api.dart';
import 'package:mismedidasb/domain/menu/i_menu_converter.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';

class MenuApi extends BaseApi implements IMenuApi{
  final NetworkHandler _networkHandler;
  final IMenuConverter _iMenuConverter;

  MenuApi(this._networkHandler, this._iMenuConverter);

  @override
  Future<List<MenuModel>> getCustomMenus({int page = 1, int perPage = 50}) async {
    final res = await _networkHandler.get(path: "${Endpoint.custom_menus}?perPage=$perPage&page=$page");
    if(res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l.map((e) => _iMenuConverter.fromJson(e)).toList();
    }
    throw serverException(res);
  }
}