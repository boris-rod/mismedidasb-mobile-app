import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SettingsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final IAccountRepository _iAccountRepository;
  final ISessionRepository _iSessionRepository;
  final ILNM _ilnm;

  SettingsBloC(this._sharedPreferencesManager, this._iAccountRepository,
      this._iSessionRepository, this._ilnm);

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

    final DateTime breakFastTime = await _sharedPreferencesManager
        .getDateTimeValue(SharedKey.breakFastTime);
    final bool showBreakFastTime = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showBreakFastTime);
    settingModel.breakfastTime = breakFastTime;
    settingModel.showBreakFastNoti = showBreakFastTime;

    final DateTime snack1Time =
        await _sharedPreferencesManager.getDateTimeValue(SharedKey.snack1Time);
    final bool showSnack1Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack1Time);
    settingModel.snack1Time = snack1Time;
    settingModel.showSnack1Noti = showSnack1Time;

    final DateTime lunchTime =
        await _sharedPreferencesManager.getDateTimeValue(SharedKey.lunchTime);
    final bool showLunchTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showLunchTime);
    settingModel.lunchTime = lunchTime;
    settingModel.showLunchNoti = showLunchTime;

    final DateTime snack2Time =
        await _sharedPreferencesManager.getDateTimeValue(SharedKey.snack2Time);
    final bool showSnack2Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack2Time);
    settingModel.snack2Time = snack2Time;
    settingModel.showSnack2Noti = showSnack2Time;

    final DateTime dinnerTime =
        await _sharedPreferencesManager.getDateTimeValue(SharedKey.dinnerTime);
    final bool showDinnerTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDinnerTime);
    settingModel.dinnerTime = dinnerTime;
    settingModel.showDinnerNoti = showDinnerTime;

    final DateTime drinkWaterTime = await _sharedPreferencesManager
        .getDateTimeValue(SharedKey.drinkWater1Time);
    final bool showDrinkWaterTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDrinkWater);
    settingModel.drinkWaterTime = drinkWaterTime;
    settingModel.showDrinkWaterNoti = showDrinkWaterTime;

    final DateTime planFoodsTime = await _sharedPreferencesManager
        .getDateTimeValue(SharedKey.planFoodsTime);
    final bool showPlanFoods =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showPlanFoods);
    settingModel.planFoodsTime = planFoodsTime;
    settingModel.showPlanFoodsNoti = showPlanFoods;

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

  Future<void> activeReminder(String sharedKey, bool active) async {
    final currentSetting = await settingsResult.first;
    await _sharedPreferencesManager.setBoolValue(sharedKey, active);
    if (sharedKey == SharedKey.showBreakFastTime) {
      currentSetting.showBreakFastNoti = active;

      if (active) {
        await _ilnm.initBreakFastReminder();
      } else {
        await _ilnm.cancel(LNM.breakFastIdReminderId);
      }
    } else if (sharedKey == SharedKey.showSnack1Time) {
      currentSetting.showSnack1Noti = active;
      if (active) {
        await _ilnm.initSnack1Reminder();
      } else {
        await _ilnm.cancel(LNM.snack1IdReminderId);
      }
    } else if (sharedKey == SharedKey.showLunchTime) {
      currentSetting.showLunchNoti = active;
      if (active) {
        await _ilnm.initLunchReminder();
      } else {
        await _ilnm.cancel(LNM.lunchIdReminderId);
      }
    } else if (sharedKey == SharedKey.showSnack2Time) {
      currentSetting.showSnack2Noti = active;
      if (active) {
        await _ilnm.initSnack2Reminder();
      } else {
        await _ilnm.cancel(LNM.snack2IdReminderId);
      }
    } else if (sharedKey == SharedKey.showDinnerTime) {
      currentSetting.showDinnerNoti = active;
      if (active) {
        await _ilnm.initDinnerReminder();
      } else {
        await _ilnm.cancel(LNM.dinnerIdReminderId);
      }
    } else if (sharedKey == SharedKey.showPlanFoods) {
      currentSetting.showPlanFoodsNoti = active;
      if (active) {
        await _ilnm.initPlanFoodsReminder();
      } else {
        await _ilnm.cancel(LNM.planFoodsId);
      }
    } else if (sharedKey == SharedKey.showDrinkWater) {
      currentSetting.showDrinkWaterNoti = active;
      if (active) {
        await _ilnm.initDrinkWater1Reminder();
        await _ilnm.initDrinkWater2Reminder();
      } else {
        await _ilnm.cancel(LNM.drinkWater1Id);
        await _ilnm.cancel(LNM.drinkWater2Id);
      }
    }

    _settingsController.sinkAddSafe(currentSetting);
  }

  void scheduleReminder(String sharedKey, DateTime time) async {
    final DateTime now = DateTime.now();
    if (now.compareTo(time) > 0) {
      final DateTime newDateTime = now.add(Duration(days: 1));
      time = DateTime(newDateTime.year, newDateTime.month, newDateTime.day,
          time.hour, time.minute, time.second);
    }
    final currentSetting = await settingsResult.first;
    await _sharedPreferencesManager.setDateTimeValue(sharedKey, time);
    if (sharedKey == SharedKey.breakFastTime) {
      currentSetting.breakfastTime = time;
      await activeReminder(SharedKey.showBreakFastTime, false);
      await activeReminder(SharedKey.showBreakFastTime, true);
    } else if (sharedKey == SharedKey.snack1Time) {
      currentSetting.snack1Time = time;
      await activeReminder(SharedKey.showSnack1Time, false);
      await activeReminder(SharedKey.showSnack1Time, true);
    } else if (sharedKey == SharedKey.lunchTime) {
      currentSetting.lunchTime = time;
      await activeReminder(SharedKey.showLunchTime, false);
      await activeReminder(SharedKey.showLunchTime, true);
    } else if (sharedKey == SharedKey.snack2Time) {
      currentSetting.snack2Time = time;
      await activeReminder(SharedKey.showSnack2Time, false);
      await activeReminder(SharedKey.showSnack2Time, true);
    } else if (sharedKey == SharedKey.dinnerTime) {
      currentSetting.dinnerTime = time;
      await activeReminder(SharedKey.showDinnerTime, false);
      await activeReminder(SharedKey.showDinnerTime, true);
    } else if (sharedKey == SharedKey.planFoodsTime) {
      currentSetting.planFoodsTime = time;
      await activeReminder(SharedKey.showPlanFoods, false);
      await activeReminder(SharedKey.showPlanFoods, true);
    } else if (sharedKey == SharedKey.drinkWater1Time) {
      currentSetting.drinkWaterTime = time;
      await _sharedPreferencesManager.setDateTimeValue(
          SharedKey.drinkWater2Time,
          time.hour > 14
              ? time.subtract(Duration(hours: 5))
              : time.add(Duration(hours: 4)));
      await activeReminder(SharedKey.showDrinkWater, false);
      await activeReminder(SharedKey.showDrinkWater, true);
    }
  }

//
//  void setShowResumeBeforeSave(bool value) async {
//    final currentSetting = await settingsResult.first;
//    currentSetting.showResumeBeforeSave = value;
//    await _sharedPreferencesManager.setShowDailyResume(value);
//    _settingsController.sinkAddSafe(currentSetting);
//  }

  void logout() async {
    isLoading = true;
    final res = await _iSessionRepository.logout();
    await _sharedPreferencesManager.cleanLogout();
    settingAction = SettingAction.logout;
    _logoutController.sinkAddSafe(true);
    isLoading = false;
  }

  void removeAccount() async {
    final forceRemove = await forceRemoveResult.first;
    isLoading = true;
    final res = await _iAccountRepository.removeAccount(!forceRemove);
    if (res is ResultSuccess<bool> && res.value) {
      settingAction = SettingAction.removeAccount;
      _removeAccountController.sinkAddSafe(true);
      await _sharedPreferencesManager.init();
      await _ilnm.cancelAll();
    } else {
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
