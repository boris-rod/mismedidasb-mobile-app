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
import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

class ProfileBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final ISessionRepository _iSessionRepository;
  final ICommonRepository _iCommonRepository;
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  ProfileBloC(this._iSessionRepository, this._iCommonRepository,
      this._iUserRepository, this._sharedPreferencesManager);

  BehaviorSubject<bool> _logoutController = new BehaviorSubject();

  Stream<bool> get logoutResult => _logoutController.stream;

  BehaviorSubject<UserModel> _userController = new BehaviorSubject();

  Stream<UserModel> get userResult => _userController.stream;

  String currentPassword = "";
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
    } else{
      isLoading = false;
      showErrorMessage(res);
    }

  }

  void removeAvatar() async {}

  void logout() async {
    isLoading = true;
    final res = await _iSessionRepository.logout();
    await _sharedPreferencesManager.cleanAll();
    _logoutController.sinkAddSafe(true);
    isLoading = false;
  }

  @override
  void dispose() {
    _logoutController.close();
    _userController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
