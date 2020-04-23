import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SettingsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final IAccountRepository _iAccountRepository;

  SettingsBloC(this._sharedPreferencesManager, this._iAccountRepository);

  BehaviorSubject<SettingModel> _settingsController = new BehaviorSubject();

  Stream<SettingModel> get settingsResult => _settingsController.stream;

  bool mustReload = false;

  void initData() async {
    isLoading = true;
    final settingModel = SettingModel();
    final locale = await _sharedPreferencesManager.getLanguageCode();
    final showResumeBeforeSave =
        await _sharedPreferencesManager.getShowDailyResume();
    settingModel.showResumeBeforeSave = showResumeBeforeSave;

    final settingRes = await _iAccountRepository.getSettings();
    if (settingRes is ResultSuccess<SettingModel>) {
      await _sharedPreferencesManager
          .setLanguageCodeId(settingRes.value.languageCodeId);

      settingModel.languageCodeId = settingRes.value.languageCodeId;
      settingModel.languageCode = settingRes.value.languageCode;

      if (locale != settingModel.languageCode) {
        await _sharedPreferencesManager
            .setLanguageCode(settingModel.languageCode);
        languageCodeController.sinkAddSafe(settingModel);
      }
    } else {
      settingModel.languageCode = locale;
      showErrorMessage(settingRes);
    }

    _settingsController.sinkAddSafe(settingModel);
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
      mustReload = true;
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

  @override
  void dispose() {
    _settingsController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
