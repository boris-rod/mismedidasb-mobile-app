
import 'package:mismedidasb/data/api/remote/result.dart';
import 'menu_model.dart';

abstract class ICustomMenuRepository {

  Future<Result<List<MenuModel>>> getCustomMenus();

}