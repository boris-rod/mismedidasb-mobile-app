import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/fcm/fcm_message_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();


class AppBloC extends BaseBloC {
  final ILNM _ilnm;

  AppBloC(this._ilnm);

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
