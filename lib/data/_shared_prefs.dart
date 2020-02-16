import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final _accessToken = "access_token";
  final _refreshToken = "refresh_token";
  final _userEmail = "user_email";
  final _password = "password";
  final _userId = "user_id";
  final _saveCredentials = "save_credentials";
  final _activeAccount = "save_credentials";

  Future<bool> cleanAll() async {
    setUserEmail('');
    setAccessToken('');
    setUserId(-1);
    setPassword('');
    setSaveCredentials(false);
    setActivateAccount(false);
    return true;
  }

  Future<bool> getActivateAccount() async {
    var value =
        (await SharedPreferences.getInstance()).getBool(_saveCredentials);
    if (value == null) {
      value = false;
      setActivateAccount(value);
    }
    return value;
  }

  Future<bool> setActivateAccount(bool newValue) async {
    var res = (await SharedPreferences.getInstance())
        .setBool(_saveCredentials, newValue);
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
      setAccessToken(value);
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
