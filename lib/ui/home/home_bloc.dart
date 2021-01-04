import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/lnm/local_notification_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/rt/i_real_time_container.dart';
import 'package:mismedidasb/rt/real_time_container.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HomeBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IHealthConceptRepository _iHealthConceptRepository;
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final ILNM lnm;
  final IRealTimeContainer _iRealTimeContainer;

  HomeBloC(this._iHealthConceptRepository, this._iUserRepository,
      this._sharedPreferencesManager, this.lnm, this._iRealTimeContainer);

  BehaviorSubject<List<HealthConceptModel>> _conceptController =
      new BehaviorSubject();

  Stream<List<HealthConceptModel>> get conceptResult =>
      _conceptController.stream;

  BehaviorSubject<bool> _launchNotiPollController = new BehaviorSubject();

  Stream<bool> get launchNotiPollResult => _launchNotiPollController.stream;

  BehaviorSubject<bool> _showFirstTimeController = new BehaviorSubject();

  Stream<bool> get showFirstTimeResult => _showFirstTimeController.stream;

  String userName = "";
  bool profileLoaded = false;
  bool conceptsLoaded = false;
  bool termsAccepted = false;
  bool needUpdateVersion = false;
  String nextVersion = "";
  String currentVersion = "";

  void loadHomeData() async {
    isLoading = true;
    profileLoaded = false;
    conceptsLoaded = false;

    ///This code can be removed for future versions
    final reInitReminders = await _sharedPreferencesManager
        .getBoolValue(SharedKey.reInitReminders, defValue: true);
    if (reInitReminders) {
      await lnm.cancelAll();
      await lnm.initReminders();
      await _sharedPreferencesManager.setBoolValue(
          SharedKey.reInitReminders, false);
    }

    final res = await _iUserRepository.getAppVersion();
    if (res is ResultSuccess<AppVersionModel>) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;
      nextVersion = res.value.version;
      needUpdateVersion =
          nextVersion != currentVersion && res.value.isMandatory;
    }
    loadProfile();
    loadConcepts();
  }

  void loadProfile() async {
    final profileRes = await _iUserRepository.getProfile();
    profileLoaded = true;
    if (conceptsLoaded) {
      isLoading = false;
      launchFirstTime();
    }
    if (profileRes is ResultSuccess<UserModel>) {
      termsAccepted = profileRes.value.termsAndConditionsAccepted;

      bool hasPlani = false;

      final plani = profileRes.value.subscriptions.firstWhere(
          (element) =>
              element.product == RemoteConstants.subscription_virtual_assessor,
          orElse: () {
        return null;
      });
      if (plani != null) {
        hasPlani = CalendarUtils.compare(plani.validAt, DateTime.now()) >= 0;
      }

      await _sharedPreferencesManager.setBoolValue(
          SharedKey.hasPlaniVirtualAssesor, hasPlani);
      if (hasPlani) {
        await lnm.initReminders();
      } else {
        await lnm.cancelAll();
      }

      await _sharedPreferencesManager.setStringValue(
          SharedKey.userName, profileRes.value.username);

      userName = profileRes.value.username;
      await _sharedPreferencesManager.setDailyKCal(profileRes.value.dailyKCal);
      await _sharedPreferencesManager.setIMC(profileRes.value.imc);
      await _sharedPreferencesManager
          .setFirstDateHealthResult(profileRes.value.firstDateHealthResult);
    } else
      showErrorMessage(profileRes);
  }

  void loadConcepts() async {
    final res = await _iHealthConceptRepository.getHealthConceptList();
    conceptsLoaded = true;
    if (profileLoaded) {
      isLoading = false;
      launchFirstTime();
    }
    if (res is ResultSuccess<List<HealthConceptModel>>) {
      _conceptController.sinkAddSafe(res.value);
    } else
      showErrorMessage(res);
  }

  void launchFirstTime() async {
    final value = await _sharedPreferencesManager
        .getBoolValue(SharedKey.firstTimeInHome, defValue: true);
    _showFirstTimeController.sinkAddSafe(value);
  }

  void setNotFirstTime() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInHome, false);
    _showFirstTimeController.sinkAddSafe(false);
  }

  Future<bool> canNavigateToDishes() async {
    final kCal = await _sharedPreferencesManager.getDailyKCal();
    final imc = await _sharedPreferencesManager.getIMC();
    return kCal > 1 && imc > 1;
  }

  String getImageTitle(String codeName) {
    String image = R.image.autocontrol;
    if (codeName == 'health-measures') {
      image = R.image.medidas_salud;
    } else if (codeName == 'value-measures') {
      image = R.image.medidas_valores;
    } else if (codeName == 'welness-measures') {
      image = R.image.medidas_bienestar;
    } else if (codeName == 'habits') {
      image = R.image.habitos_saludables;
    } else if (codeName == 'dishes') {
      image = R.image.plan_comidas;
    }
    return image;
  }

  String getImage(String codeName) {
    String image = R.image.food_craving_home;
    if (codeName == 'health-measures') {
      image = R.image.health_home;
    } else if (codeName == 'value-measures') {
      image = R.image.values_home;
    } else if (codeName == 'welness-measures') {
      image = R.image.wellness_home;
    } else if (codeName == 'habits') {
      image = R.image.habits_home;
    } else if (codeName == 'dishes') {
      image = R.image.dishes_home;
    }
    return image;
  }

  int getHomeCountPerRow(double screenW) {
    int count = 0;
    double partialW = 0;
    while (screenW > partialW + R.dim.homeWidgetDimen) {
      count += 1;
      partialW += partialW + R.dim.homeWidgetDimen;
    }
    return count;
  }

  String getDefaultHomeImage(HealthConceptModel model) {
    String resDir = R.image.logo;
    if (model.codeName == RemoteConstants.concept_health_measure)
      resDir = R.image.health_home;
    else if (model.codeName == RemoteConstants.concept_values_measure)
      resDir = R.image.values_home;
    else if (model.codeName == RemoteConstants.concept_wellness_measure)
      resDir = R.image.wellness_home;
    else if (model.codeName == RemoteConstants.concept_dishes)
      resDir = R.image.dishes_home;
    else if (model.codeName == RemoteConstants.concept_habits)
      resDir = R.image.habits_home;
    else if (model.codeName == RemoteConstants.concept_craving)
      resDir = R.image.food_craving_home;

    return resDir;
  }

  @override
  void dispose() {
    _conceptController.close();
    _launchNotiPollController.close();
    _showFirstTimeController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
//    _loadingController.close();
  }
}
