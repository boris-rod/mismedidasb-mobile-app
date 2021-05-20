
import 'package:mismedidasb/domain/menu/menu_model.dart';

abstract class IMenuApi {

  Future<List<MenuModel>> getCustomMenus({int page = 1, int perPage = 50});
}