import 'dart:io';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/common_db/i_common_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../enums.dart';

class ProfileBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  ProfileBloC(this._iUserRepository, this._sharedPreferencesManager);

  BehaviorSubject<UserModel> _userController = new BehaviorSubject();

  Stream<UserModel> get userResult => _userController.stream;

  SettingAction settingAction;
  String currentPassword = "";

  set updateUser(UserModel user) {
    _userController.sinkAddSafe(user);
  }

  void getProfile() async {
    currentPassword = await _sharedPreferencesManager.getPassword();
    isLoading = true;
    final res = await _iUserRepository.getProfile();
    if (res is ResultSuccess<UserModel>) {
      _userController.sinkAddSafe(res.value);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void updateProfile() async {}

  void uploadAvatar(File file) async {
    isLoading = true;
    final res = await _iUserRepository.uploadAvatar(file);
    if (res is ResultSuccess<bool>) {
      getProfile();
    } else {
      isLoading = false;
      showErrorMessage(res);
    }
  }

  void updatePlani(int id) async {
    _sharedPreferencesManager.setIntValue(SharedKey.planiId, id);
  }

  void removeAvatar() async {}

  @override
  void dispose() {
    _userController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
