import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedKey {
  static String firstUse = "firstUse";
  static String accessToken = "accessToken";
  static String refreshToken = "refreshToken";
  static String userEmail = "userEmail";
  static String password = "password";
  static String userId = "userId";
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
  static String showIntro = "showIntro";
}

class SharedPreferencesManager {
  Future<bool> init() async {
    await setStringValue(SharedKey.accessToken, '');
    await setStringValue(SharedKey.refreshToken, '');
    await setStringValue(SharedKey.password, '');

    await setBoolValue(SharedKey.firstUse, true);
    await setBoolValue(SharedKey.saveCredentials, true);
    await setBoolValue(SharedKey.showDailyResume, true);
    await setBoolValue(SharedKey.kCalPercentageHide, true);
    await setBoolValue(SharedKey.nutriInfoExpanded, false);
    await setBoolValue(SharedKey.showIntro, true);

    await setIntValue(SharedKey.activeAccount, ACCOUNT_STATUS.PENDING.index);
    return true;
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

  Future<int> getActivateAccount() async {
    var value =
        (await SharedPreferences.getInstance()).getInt(SharedKey.activeAccount);
    if (value == null) {
      value = ACCOUNT_STATUS.PENDING.index;
      setActivateAccount(value);
    }
    return value;
  }

  Future<bool> setActivateAccount(int newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setInt(SharedKey.activeAccount, newValue);
    return res;
  }

  Future<bool> getTermsCond() async {
    var value =
        (await SharedPreferences.getInstance()).getBool(SharedKey.termsCond);
    if (value == null) {
      value = false;
      setTermsCond(value);
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
      setFirstDateHealthResult(now);
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
      setSaveCredentials(value);
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
      setDailyKCal(value);
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
      setIMC(value);
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
      setShowDailyResume(value);
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
      setUserEmail(value);
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
      setLanguageCode(value);
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
      setPassword(value);
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
      setAccessToken(value);
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
      setRefreshToken(value);
    }
    return value;
  }

  Future<bool> setRefreshToken(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(SharedKey.refreshToken, newValue);
    return res;
  }

  Future<int> getUserId() async {
    var value =
        (await SharedPreferences.getInstance()).getInt(SharedKey.userId);
    if (value == null) {
      value = -1;
      setUserId(value);
    }
    return value;
  }

  Future<bool> setUserId(int newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setInt(SharedKey.userId, newValue);
    return res;
  }

  Future<int> getLanguageCodeId() async {
    var value = (await SharedPreferences.getInstance())
        .getInt(SharedKey.languageCodeId);
    if (value == null) {
      value = 0;
      setLanguageCodeId(value);
    }
    return value;
  }

  Future<bool> setLanguageCodeId(int newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setInt(SharedKey.languageCodeId, newValue);
    return res;
  }
}
