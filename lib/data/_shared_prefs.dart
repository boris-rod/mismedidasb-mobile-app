import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final _accessToken = "access_token1";
  final _refreshToken = "refresh_token1";
  final _userEmail = "user_email1";
  final _password = "password1";
  final _userId = "user_id1";
  final _saveCredentials = "save_credentials1";
  final _activeAccount = "active_account1";
  final _dailyKCal = "daily_cal1";
  final _imc = "imc1";
  final _firstDateHealthResult = "first_date_health_result1";
  final _showDailyResume = "show_daily_resume";
  final _languageCode = "language_code";

  Future<bool> cleanAll() async {
//    setUserEmail('');
    setAccessToken('');
//    setUserId(-1);
    setPassword('');
    setSaveCredentials(false);
    setActivateAccount(ACCOUNT_STATUS.PENDING.index);
    setShowDailyResume(true);
    return true;
  }

  Future<int> getActivateAccount() async {
    var value = (await SharedPreferences.getInstance()).getInt(_activeAccount);
    if (value == null) {
      value = ACCOUNT_STATUS.PENDING.index;
      setActivateAccount(value);
    }
    return value;
  }

  Future<bool> setActivateAccount(int newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setInt(_activeAccount, newValue);
    return res;
  }

  Future<DateTime> getFirstDateHealthResult() async {
    var value = (await SharedPreferences.getInstance()).getString(_firstDateHealthResult);
    if (value == null) {
      final now = DateTime.now();
      value = now.toIso8601String();
      setFirstDateHealthResult(now);
    }
    return DateTime.parse(value);
  }

  Future<bool> setFirstDateHealthResult(DateTime newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(_firstDateHealthResult, newValue.toIso8601String());
    return res;
  }

  Future<bool> getSaveCredentials() async {
    var value =
        (await SharedPreferences.getInstance()).getBool(_saveCredentials);
    if (value == null) {
      value = false;
      setSaveCredentials(value);
    }
    return value;
  }

  Future<bool> setSaveCredentials(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(_saveCredentials, newValue);
    return res;
  }

  Future<double> getDailyKCal() async {
    var value = (await SharedPreferences.getInstance()).getDouble(_dailyKCal);
    if (value == null || value < 1) {
      value = 1;
      setDailyKCal(value);
    }
    return value;
  }

  Future<bool> setDailyKCal(double newValue) async {
    var res =
        (await SharedPreferences.getInstance()).setDouble(_dailyKCal, newValue);
    return res;
  }

  Future<double> getIMC() async {
    var value = (await SharedPreferences.getInstance()).getDouble(_imc);
    if (value == null || value < 1) {
      value = 1;
      setIMC(value);
    }
    return value;
  }

  Future<bool> setIMC(double newValue) async {
    var res = (await SharedPreferences.getInstance()).setDouble(_imc, newValue);
    return res;
  }

  Future<bool> getShowDailyResume() async {
    var value =
        (await SharedPreferences.getInstance()).getBool(_showDailyResume);
    if (value == null) {
      value = true;
      setShowDailyResume(value);
    }
    return value;
  }

  Future<bool> setShowDailyResume(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(_showDailyResume, newValue);
    return res;
  }

  Future<String> getUserEmail() async {
    var value = (await SharedPreferences.getInstance()).getString(_userEmail);
    if (value == null) {
      value = '';
      setUserEmail(value);
    }
    return value;
  }

  Future<bool> setUserEmail(String newValue) async {
    var res =
        (await SharedPreferences.getInstance()).setString(_userEmail, newValue);
    return res;
  }

  Future<String> getLanguageCode() async {
    var value = (await SharedPreferences.getInstance()).getString(_languageCode);
    if (value == null) {
      value = '';
      setLanguageCode(value);
    }
    return value;
  }

  Future<bool> setLanguageCode(String newValue) async {
    var res =
    (await SharedPreferences.getInstance()).setString(_languageCode, newValue);
    return res;
  }

  Future<String> getPassword() async {
    var value = (await SharedPreferences.getInstance()).getString(_password);
    if (value == null) {
      value = '';
      setPassword(value);
    }
    return value;
  }

  Future<bool> setPassword(String newValue) async {
    var res =
        (await SharedPreferences.getInstance()).setString(_password, newValue);
    return res;
  }

  Future<String> getAccessToken() async {
    var value = (await SharedPreferences.getInstance()).getString(_accessToken);
    if (value == null) {
      value = '';
      setAccessToken(value);
    }
    return value;
  }

  Future<bool> setAccessToken(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(_accessToken, newValue);
    return res;
  }

  Future<String> getRefreshToken() async {
    var value =
        (await SharedPreferences.getInstance()).getString(_refreshToken);
    if (value == null) {
      value = '';
      setRefreshToken(value);
    }
    return value;
  }

  Future<bool> setRefreshToken(String newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setString(_refreshToken, newValue);
    return res;
  }

  Future<int> getUserId() async {
    var value = (await SharedPreferences.getInstance()).getInt(_userId);
    if (value == null) {
      value = -1;
      setUserId(value);
    }
    return value;
  }

  Future<bool> setUserId(int newValue) async {
    var res = (await SharedPreferences.getInstance()).setInt(_userId, newValue);
    return res;
  }
}
