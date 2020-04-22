import 'dart:ui';

import 'package:mismedidasb/data/_shared_prefs.dart';
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

  SettingsBloC(this._sharedPreferencesManager);

  BehaviorSubject<SettingModel> _settingsController = new BehaviorSubject();

  Stream<SettingModel> get settingsResult => _settingsController.stream;

  bool mustReload = false;

  void initData() async {
    final settingModel = SettingModel();
    final showResumeBeforeSave =
        await _sharedPreferencesManager.getShowDailyResume();
    final locale = await _sharedPreferencesManager.getLanguageCode();

    settingModel.showResumeBeforeSave = showResumeBeforeSave;
    settingModel.languageCode = locale;

    _settingsController.sinkAddSafe(settingModel);
  }

  void setLanguageCode(String code) async {
    isLoading = true;
    Future.delayed(Duration(seconds: 2), () async {
      await _sharedPreferencesManager.setLanguageCode(code);
      languageCodeController.sinkAddSafe(SettingModel(languageCode: code, isDarkMode: false));
      final settings = await settingsResult.first;
      settings.languageCode = code;
      _settingsController.sinkAddSafe(settings);
      mustReload = true;
      isLoading = false;
    });
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
