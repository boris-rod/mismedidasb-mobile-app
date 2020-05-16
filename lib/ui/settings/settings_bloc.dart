import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SettingsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final IAccountRepository _iAccountRepository;
  final ISessionRepository _iSessionRepository;

  SettingsBloC(this._sharedPreferencesManager, this._iAccountRepository,
      this._iSessionRepository);

  BehaviorSubject<SettingModel> _settingsController = new BehaviorSubject();

  Stream<SettingModel> get settingsResult => _settingsController.stream;

  BehaviorSubject<bool> _logoutController = new BehaviorSubject();

  Stream<bool> get logoutResult => _logoutController.stream;

  BehaviorSubject<bool> _forceRemoveController = new BehaviorSubject();

  Stream<bool> get forceRemoveResult => _forceRemoveController.stream;

  set forceRemoveAccount(bool value) {
    _forceRemoveController.sinkAddSafe(value);
  }

  BehaviorSubject<bool> _removeAccountController = new BehaviorSubject();

  Stream<bool> get removeAccountResult => _removeAccountController.stream;

  SettingAction settingAction;

  void initData() async {
    isLoading = true;
    final settingModel = SettingModel();
    final locale = await _sharedPreferencesManager.getLanguageCode();
    final showResumeBeforeSave =
        await _sharedPreferencesManager.getShowDailyResume();
    settingModel.showResumeBeforeSave = showResumeBeforeSave;

//    final settingRes = await _iAccountRepository.getSettings();
//    if (settingRes is ResultSuccess<SettingModel>) {
//      await _sharedPreferencesManager
//          .setLanguageCodeId(settingRes.value.languageCodeId);
//
//      settingModel.languageCodeId = settingRes.value.languageCodeId;
//      settingModel.languageCode = settingRes.value.languageCode;
//
//      if (locale != settingModel.languageCode) {
//        await _sharedPreferencesManager
//            .setLanguageCode(settingModel.languageCode);
//        languageCodeController.sinkAddSafe(settingModel);
//      }
//    } else {
//      settingModel.languageCode = locale;
//      showErrorMessage(settingRes);
//    }

    _settingsController.sinkAddSafe(settingModel);

    _forceRemoveController.sinkAddSafe(false);
    isLoading = false;
  }

  void setLanguageCode(String code) async {
    isLoading = true;
    final currentSetting = await settingsResult.first;
    final res = await _iAccountRepository.saveSettings(SettingModel(
        languageCodeId: currentSetting.languageCodeId,
        languageCode: code,
        isDarkMode: false));
    if (res is ResultSuccess<bool>) {
      currentSetting.languageCode = code;
      await _sharedPreferencesManager.setLanguageCode(code);
      languageCodeController.sinkAddSafe(currentSetting);
      _settingsController.sinkAddSafe(currentSetting);
      settingAction = SettingAction.languageCodeChanged;
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void setShowResumeBeforeSave(bool value) async {
    final currentSetting = await settingsResult.first;
    currentSetting.showResumeBeforeSave = value;
    await _sharedPreferencesManager.setShowDailyResume(value);
    _settingsController.sinkAddSafe(currentSetting);
  }

  void logout() async {
    isLoading = true;
    final res = await _iSessionRepository.logout();
    await _sharedPreferencesManager.cleanAll();
    settingAction = SettingAction.logout;
    _logoutController.sinkAddSafe(true);
    isLoading = false;
  }

  void removeAccount() async {
    final forceRemove = await forceRemoveResult.first;
    isLoading = true;
    final res = await _iAccountRepository.removeAccount(!forceRemove);
    if(res is ResultSuccess<bool> && res.value){
      settingAction = SettingAction.removeAccount;
      _removeAccountController.sinkAddSafe(true);
    }else{
      _removeAccountController.sinkAddSafe(false);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _settingsController.close();
    _forceRemoveController.close();
    _logoutController.close();
    _removeAccountController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
