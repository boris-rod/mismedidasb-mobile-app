

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class CustomMenusBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IDishRepository _iDishRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  CustomMenusBloC(this._iDishRepository, this._sharedPreferencesManager);

  @override
  void dispose() {

  }

  void initData() async {
    final res = await _iDishRepository.getCustomMenus();
  }

}