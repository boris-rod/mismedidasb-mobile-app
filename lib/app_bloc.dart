import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/utils/extensions.dart';

import 'lnm/lnm.dart';
import 'lnm/local_notification_model.dart';

class AppBloC extends BaseBloC {
  final SharedPreferencesManager _sharedPreferencesManager;

  AppBloC(this._sharedPreferencesManager);

//  void resolveInitialSettings(SettingModel settingModel) async {
//    String locale = await _sharedPreferencesManager.getLanguageCode();
//    if (locale.isEmpty) {
//      if (["es", "en", "it"].contains(settingModel.languageCode))
//        locale = settingModel.languageCode;
//      else
//        locale = "es";
//    }
//    await _sharedPreferencesManager.setLanguageCode(locale);
//    languageCodeController.sinkAddSafe(settingModel);
//  }

  @override
  void dispose() {}
}
