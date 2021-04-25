import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/menu/i_menu_repository.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

import '../../enums.dart';

class CustomMenusBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final ICustomMenuRepository _iCustomMenuRepository;
  final IDishRepository _iDishRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final IUserRepository _iUserRepository;

  CustomMenusBloC(this._iCustomMenuRepository, this._iDishRepository,
      this._sharedPreferencesManager, this._iUserRepository);

  @override
  void dispose() {
    _menusController.close();
    disposeErrorHandlerBloC();
    disposeLoadingBloC();
  }

  BehaviorSubject<List<MenuModel>> _menusController = BehaviorSubject();

  Stream<List<MenuModel>> get menusResult => _menusController.stream;

  int currentPage = 1;
  int currentPerPage = 50;
  bool isLoadingMore = false;
  bool hasMore = true;

  UserModel profile;
  bool hasSubscription = false;

  void initData() async {
    isLoading = true;
    final resProfile = await _iUserRepository.getProfile();
    if (resProfile is ResultSuccess<UserModel>) {
      profile = resProfile.value;
      hasSubscription = resProfile.value.subscriptions
              .firstWhere((element) => element.product == "MENUES",
                  orElse: () => null)
              ?.isActive ??
          false;
    }
    final res = await _iCustomMenuRepository.getCustomMenus(
        perPage: currentPerPage, page: currentPage);
    if (res is ResultSuccess<List<MenuModel>>) {
      _menusController.sinkAddSafe(res.value);
      if (res.value.length < currentPerPage) hasMore = false;
    } else {
      showErrorMessageAsString("Error al intentar cargar los datos");
    }
    isLoading = false;
  }

  void loadMore() async {
    if (hasMore && !isLoadingMore) {
      isLoadingMore = true;
      final res = await _iCustomMenuRepository.getCustomMenus(
          perPage: currentPerPage, page: ++currentPage);
      if (res is ResultSuccess<List<MenuModel>>) {
        List<MenuModel> menus = (_menusController.value ?? []);
        menus.addAll(res.value);
        _menusController.sinkAddSafe(menus);
        if (res.value.length < currentPerPage) hasMore = false;
      }
      isLoadingMore = false;
    }
  }

  void markUnMarkFood(int index, dailyActivityFoodId, int foodId,
      FoodsTypeMark foodsTypeMark, bool mark) async {
    final menus = _menusController.value ?? [];
    if (index < menus.length) {
      final foodModel = menus[index]
          ?.dailyEats
          ?.firstWhere((element) => element.id == dailyActivityFoodId)
          ?.foods
          ?.firstWhere((element) => element.id == foodId);
      if (foodsTypeMark == FoodsTypeMark.lackSelfControl) {
        if (mark)
          _iDishRepository.addLackSelfControl(foodId);
        else
          _iDishRepository.removeLackSelfControl(foodId);
        if (foodModel != null) foodModel.isLackSelfControlDish = mark;
      } else {
        if (mark)
          _iDishRepository.addFoodToFavorites(foodId);
        else
          _iDishRepository.removeFoodFromFavorites(foodId);
        if (foodModel != null) foodModel.isFavorite = mark;
      }
      _menusController.sinkAddSafe(menus);
    }
  }
}
