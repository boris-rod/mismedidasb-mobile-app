import 'dart:io';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class ProfileEditBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  ProfileEditBloC(this._iUserRepository, this._sharedPreferencesManager);

  BehaviorSubject<UserModel> _userController = new BehaviorSubject();

  Stream<UserModel> get userResult => _userController.stream;

  String currentPassword = "";
  bool userEdited = false;

  void initData(UserModel model) async {
    currentPassword = await _sharedPreferencesManager.getPassword();
    _userController.sinkAddSafe(model);
  }

  void updateProfile() async {
    isLoading = true;
//    final res = await _iUserRepository.updateProfile(userModel);
    isLoading = false;
  }

  void updateUserName(String userName) async {
    final user = await userResult.first;
    if (user.fullName.trim().toLowerCase() == userName.trim().toLowerCase())
      return;
    isLoading = true;
    user.fullName = userName;
    final res = await _iUserRepository.updateProfile(user);
    if (res is ResultSuccess<UserModel>) {
      _userController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void uploadAvatar(File file) async {
    isLoading = true;
    final res = await _iUserRepository.uploadAvatar(file);
    if (res is ResultSuccess<bool>) {
      final profileRes = await _iUserRepository.getProfile();
      if (profileRes is ResultSuccess<UserModel>)
        _userController.sinkAddSafe(profileRes.value);
      else
        showErrorMessage(profileRes);
      userEdited = true;
    } else {
      isLoading = false;
      showErrorMessage(res);
    }
    await FileManager.deleteFile(file.path);
  }

  @override
  void dispose() {
    _userController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
