import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedKey {
  static String firstUse = "firstUse1";
  static String accessToken = "accessToken";
  static String refreshToken = "refreshToken";
  static String userEmail = "userEmail";
  static String userName = "userName";
  static String password = "password";
  static String userId = "userId";
  static String planiId = "planiId";
  static String saveCredentials = "saveCredentials";
  static String activeAccount = "activeAccount";
  static String dailyKCal = "dailyKCal";
  static String imc = "imc";
  static String firstDateHealthResult = "firstDateHealthResult";
  static String showDailyResume = "showDailyResume";
  static String languageCode = "languageCode";
  static String languageCodeId = "languageCodeId";
  static String termsCond = "termsCond";
  static String kCalPercentageHide = "kCalPercentageHide";
  static String nutriInfoExpanded = "nutriInfoExpanded";

  static String breakFastTime = "breakFastTime";
  static String showBreakFastTime = "showBreakFastTime";
  static String snack1Time = "snack1Time";
  static String showSnack1Time = "showSnack1Time";
  static String lunchTime = "lunchTime";
  static String showLunchTime = "showLunchTime";
  static String snack2Time = "snack2Time";
  static String showSnack2Time = "showSnack2Time";
  static String dinnerTime = "dinnerTime";
  static String showDinnerTime = "showDinnerTime";

  static String physicalExerciseTime = "physicalExerciseTime";
  static String showPhysicalExerciseTime = "showPhysicalExerciseTime";
  static String showPlanFoods = "showPlanFoods";
  static String planFoodsTime = "planFoodsTime";

  static String showDrinkWater = "drinkWater";
  static String drinkWater1Time = "drinkWater1Time";
  static String drinkWater2Time = "drinkWater2Time";

  static String hasPlaniVirtualAssesor = "hasPlaniVirtualAssesor";

  static String showDailyPollNotification = "showDailyPollNotification";
  static String launchNotiPoll = "launchNotiPoll";
  static String firstTimeInHome = "firstTimeInHome";
  static String firstTimeInProfile = "firstTimeInProfile";
  static String firstTimeInMeasureHealth = "firstTimeInMeasureHealth";
  static String firstTimeInCopyPlan = "firstTimeInCopyPlan";
  static String firstTimeInFoodPlan = "firstTimeInFoodPlan";
  static String firstTimeInFoodPortions = "firstTimeInFoodPortions";
  static String firstTimeInHabits = "firstTimeInHabits";
  static String firstTimeInCraving= "firstTimeInCraving";
}

class SharedPreferencesManager {
  Future<void> cleanLogout() async {
    await setStringValue(SharedKey.accessToken, '');
    await setStringValue(SharedKey.refreshToken, '');
    await setStringValue(SharedKey.password, '');
    await setStringValue(SharedKey.userName, '');
    await setBoolValue(SharedKey.saveCredentials, true);
    await initVideoTutorials();
  }

  Future<void> initVideoTutorials() async {
    await setBoolValue(SharedKey.firstTimeInHome, true);
    await setBoolValue(SharedKey.firstTimeInProfile, true);
    await setBoolValue(SharedKey.firstTimeInMeasureHealth, true);
    await setBoolValue(SharedKey.firstTimeInCopyPlan, true);
    await setBoolValue(SharedKey.firstTimeInFoodPlan, true);
    await setBoolValue(SharedKey.firstTimeInFoodPortions, true);
    await setBoolValue(SharedKey.firstTimeInHabits, true);
    await setBoolValue(SharedKey.firstTimeInCraving, true);
  }


  Future<void> init() async {
    await cleanLogout();

    await setIntValue(SharedKey.planiId, 1);

    await setBoolValue(SharedKey.firstUse, true);

    await setBoolValue(SharedKey.showDailyResume, true);
    await setBoolValue(SharedKey.kCalPercentageHide, false);
    await setBoolValue(SharedKey.nutriInfoExpanded, false);
    await setBoolValue(SharedKey.launchNotiPoll, false);

    await setBoolValue(SharedKey.showBreakFastTime, true);
    await setBoolValue(SharedKey.showSnack1Time, true);
    await setBoolValue(SharedKey.showLunchTime, true);
    await setBoolValue(SharedKey.showSnack2Time, true);
    await setBoolValue(SharedKey.showDinnerTime, true);
    await setBoolValue(SharedKey.showPhysicalExerciseTime, true);
    await setBoolValue(SharedKey.showPlanFoods, true);
    await setBoolValue(SharedKey.showDrinkWater, true);

    await setBoolValue(SharedKey.hasPlaniVirtualAssesor, false);
    await setBoolValue(SharedKey.showDailyPollNotification, true);

    final now = DateTime.now();
    await setDateTimeValue(SharedKey.breakFastTime,
        DateTime(now.year, now.month, now.day, 8, 0, 0));

    await setDateTimeValue(SharedKey.snack1Time,
        DateTime(now.year, now.month, now.day, 10, 00, 0));

    await setDateTimeValue(
        SharedKey.lunchTime, DateTime(now.year, now.month, now.day, 12, 00, 0));

    await setDateTimeValue(SharedKey.snack2Time,
        DateTime(now.year, now.month, now.day, 16, 00, 0));

    await setDateTimeValue(
        SharedKey.dinnerTime, DateTime(now.year, now.month, now.day, 22, 0, 0));

    await setDateTimeValue(SharedKey.physicalExerciseTime,
        DateTime(now.year, now.month, now.day, 7, 0, 0));

    await setDateTimeValue(SharedKey.drinkWater1Time,
        DateTime(now.year, now.month, now.day, 11, 0, 0));

    await setDateTimeValue(SharedKey.drinkWater2Time,
        DateTime(now.year, now.month, now.day, 16, 30, 0));

    await setDateTimeValue(SharedKey.planFoodsTime,
        DateTime(now.year, now.month, now.day, 22, 00, 0));

    await setIntValue(SharedKey.activeAccount, ACCOUNT_STATUS.PENDING.index);
  }

  Future<bool> getBoolValue(String key, {bool defValue = false}) async {
    var value = (await SharedPreferences.getInstance()).getBool(key);
    if (value == null) {
      value = defValue;
      await setBoolValue(key, value);
    }
    return value;
  }

  Future<bool> setBoolValue(String key, bool newValue) async {
    final sh = await SharedPreferences.getInstance();
    var res = await sh.setBool(key, newValue);
    return res;
  }

  Future<int> getIntValue(String key, {int defValue = 0}) async {
    var value = (await SharedPreferences.getInstance()).getInt(key);
    if (value == null) {
      value = defValue;
      await setIntValue(key, value);
    }
    return value;
  }

  Future<bool> setIntValue(String key, int newValue) async {
    final sh = await SharedPreferences.getInstance();
    var res = await sh.setInt(key, newValue);
    return res;
  }

  Future<String> getStringValue(String key, {String defValue = ""}) async {
    var value = (await SharedPreferences.getInstance()).getString(key);
    if (value == null) {
      value = defValue;
      await setStringValue(key, value);
    }
    return value;
  }

  Future<bool> setStringValue(String key, String newValue) async {
    final sh = await SharedPreferences.getInstance();
    var res = await sh.setString(key, newValue);
    return res;
  }

  Future<DateTime> getDateTimeValue(String key, {DateTime defValue}) async {
    var value = (await SharedPreferences.getInstance()).getString(key);
    if (value == null) {
      final now = DateTime.now();
      value = now.toIso8601String();
      await setDateTimeValue(key, now);
    }
    return DateTime.parse(value);
  }

  Future<bool> setDateTimeValue(String key, DateTime newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(key, newValue.toIso8601String());
    return res;
  }

  Future<bool> getTermsCond() async {
    var value =
        (await SharedPreferences.getInstance()).getBool(SharedKey.termsCond);
    if (value == null) {
      value = false;
      await setTermsCond(value);
    }
    return value;
  }

  Future<bool> setTermsCond(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(SharedKey.termsCond, newValue);
    return res;
  }

  Future<DateTime> getFirstDateHealthResult() async {
    var value = (await SharedPreferences.getInstance())
        .getString(SharedKey.firstDateHealthResult);
    if (value == null) {
      final now = DateTime.now();
      value = now.toIso8601String();
      await setFirstDateHealthResult(now);
    }
    return DateTime.parse(value);
  }

  Future<bool> setFirstDateHealthResult(DateTime newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.firstDateHealthResult, newValue.toIso8601String());
    return res;
  }

  Future<bool> getSaveCredentials() async {
    var value = (await SharedPreferences.getInstance())
        .getBool(SharedKey.saveCredentials);
    if (value == null) {
      value = true;
      await setSaveCredentials(value);
    }
    return value;
  }

  Future<bool> setSaveCredentials(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(SharedKey.saveCredentials, newValue);
    return res;
  }

  Future<double> getDailyKCal() async {
    var value =
        (await SharedPreferences.getInstance()).getDouble(SharedKey.dailyKCal);
    if (value == null || value < 1) {
      value = 1;
      await setDailyKCal(value);
    }
    return value;
  }

  Future<bool> setDailyKCal(double newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setDouble(SharedKey.dailyKCal, newValue);
    return res;
  }

  Future<double> getIMC() async {
    var value =
        (await SharedPreferences.getInstance()).getDouble(SharedKey.imc);
    if (value == null || value < 1) {
      value = 1;
      await setIMC(value);
    }
    return value;
  }

  Future<bool> setIMC(double newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setDouble(SharedKey.imc, newValue);
    return res;
  }

  Future<bool> getShowDailyResume() async {
    var value = (await SharedPreferences.getInstance())
        .getBool(SharedKey.showDailyResume);
    if (value == null) {
      value = true;
      await setShowDailyResume(value);
    }
    return value;
  }

  Future<bool> setShowDailyResume(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(SharedKey.showDailyResume, newValue);
    return res;
  }

  Future<String> getUserEmail() async {
    var value =
        (await SharedPreferences.getInstance()).getString(SharedKey.userEmail);
    if (value == null) {
      value = '';
      await setUserEmail(value);
    }
    return value;
  }

  Future<bool> setUserEmail(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.userEmail, newValue);
    return res;
  }

  Future<String> getLanguageCode() async {
    var value = (await SharedPreferences.getInstance())
        .getString(SharedKey.languageCode);
    if (value == null) {
      value = '';
      await setLanguageCode(value);
    }
    return value;
  }

  Future<bool> setLanguageCode(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.languageCode, 'es');
    return res;
  }

  Future<String> getPassword() async {
    var value =
        (await SharedPreferences.getInstance()).getString(SharedKey.password);
    if (value == null) {
      value = '';
      await setPassword(value);
    }
    return value;
  }

  Future<bool> setPassword(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.password, newValue);
    return res;
  }

  Future<String> getAccessToken() async {
    var value = (await SharedPreferences.getInstance())
        .getString(SharedKey.accessToken);
    if (value == null) {
      value = '';
      await setAccessToken(value);
    }
    return value;
  }

  Future<bool> setAccessToken(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.accessToken, newValue);
    return res;
  }

  Future<String> getRefreshToken() async {
    var value = (await SharedPreferences.getInstance())
        .getString(SharedKey.refreshToken);
    if (value == null) {
      value = '';
      await setRefreshToken(value);
    }
    return value;
  }

  Future<bool> setRefreshToken(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.refreshToken, newValue);
    return res;
  }

//  Future<int> getUserId() async {
//    var value =
//        (await SharedPreferences.getInstance()).getInt(SharedKey.userId);
//    if (value == null) {
//      value = -1;
//      setUserId(value);
//    }
//    return value;
//  }
//
//  Future<bool> setUserId(int newValue) async {
//    var res = (await SharedPreferences.getInstance())
//        .setInt(SharedKey.userId, newValue);
//    return res;
//  }

  Future<int> getLanguageCodeId() async {
    var value = (await SharedPreferences.getInstance())
        .getInt(SharedKey.languageCodeId);
    if (value == null) {
      value = 0;
      await setLanguageCodeId(value);
    }
    return value;
  }

  Future<bool> setLanguageCodeId(int newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setInt(SharedKey.languageCodeId, newValue);
    return res;
  }
}
