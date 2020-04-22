import 'package:flutter/material.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/utils/extensions.dart';

class AppBloC extends BaseBloC {
  final SharedPreferencesManager _sharedPreferencesManager;

  AppBloC(this._sharedPreferencesManager);

  void resolveInitialSettings(SettingModel settingModel) async {
    String locale = await _sharedPreferencesManager.getLanguageCode();
    if (locale.isEmpty) {
      if (["es", "en", "it"].contains(settingModel.languageCode))
        locale = settingModel.languageCode;
      else
        locale = "es";
    }
    await _sharedPreferencesManager.setLanguageCode(locale);
    languageCodeController.sinkAddSafe(settingModel);
  }

  @override
  void dispose() {}
}
