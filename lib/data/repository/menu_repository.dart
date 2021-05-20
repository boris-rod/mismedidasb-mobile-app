
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/menu/i_menu_api.dart';
import 'package:mismedidasb/domain/menu/i_menu_repository.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';

class CustomMenuRepository extends BaseRepository implements ICustomMenuRepository {
  IMenuApi _iMenuApi;

  CustomMenuRepository(this._iMenuApi);

  @override
  Future<Result<List<MenuModel>>> getCustomMenus({int page = 1, int perPage = 50}) async {
    try {
      final res = await _iMenuApi.getCustomMenus(page: page, perPage: perPage);
      return ResultSuccess(value: res);
    } catch (ex) {
      return resultError(ex);
    }
  }

}