
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/menu/i_menu_repository.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class CustomMenusBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final ICustomMenuRepository _iCustomMenuRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  CustomMenusBloC(this._iCustomMenuRepository, this._sharedPreferencesManager);

  @override
  void dispose() {
    _menusController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }

  BehaviorSubject<List<MenuModel>> _menusController = BehaviorSubject();

  Stream<List<MenuModel>> get menusResult => _menusController.stream;


  void initData() async {
    isLoading = true;
    final res = await _iCustomMenuRepository.getCustomMenus();
    if(res is ResultSuccess<List<MenuModel>>) {

    }
    isLoading = false;
  }

}