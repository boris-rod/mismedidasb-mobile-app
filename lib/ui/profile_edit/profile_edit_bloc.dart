import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
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

  BehaviorSubject<UsernameSuggestionModel> _usernameValidationController =
      new BehaviorSubject();

  Stream<UsernameSuggestionModel> get usernameValidationResult =>
      _usernameValidationController.stream;

  String currentPassword = "";
  bool userEdited = false;

  void initData(UserModel model) async {
    currentPassword = await _sharedPreferencesManager.getPassword();
    _userController.sinkAddSafe(model);
    userValidation(userName: model.username);
    _usernameValidationController
        .sinkAddSafe(UsernameSuggestionModel(isValid: true, suggestions: []));
  }

  void updateProfile(String userName, String fullName) async {
    final user = await userResult.first;
    if (fullName?.trim()?.toLowerCase()?.isNotEmpty == true)
      user.fullName = fullName;
    if (userName?.trim()?.toLowerCase()?.isNotEmpty == true)
      user.username = userName;
    user.phone = "";

    isLoading = true;
    final res = await _iUserRepository.updateProfile(user);
    if (res is ResultSuccess<UserModel>) {
      Fluttertoast.showToast(
          msg: "Los datos del perfil fueron actualizados exitosamente.",
          backgroundColor: R.color.wellness_color,
          textColor: Colors.white);
      userEdited = true;
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
      showErrorMessage(res);
    }
    isLoading = false;
//    await FileManager.deleteFile(file.path);
  }

  void userValidation({String userName = ""}) async {
    final user = await userResult.first;
    final res = await _iUserRepository.usernameValidation(user.id, user.email,
        userName?.isNotEmpty == true ? userName : user.username, user.fullName);
    if (res is ResultSuccess<UsernameSuggestionModel>) {
      _usernameValidationController.sinkAddSafe(res.value);
    }
  }

  @override
  void dispose() {
    _userController.close();
    _usernameValidationController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
