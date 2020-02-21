import 'dart:convert';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_converter.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class SessionApi extends BaseApi implements ISessionApi {
  final ISessionConverter _iSessionConverter;
  final IUserConverter _iUserConverter;
  final NetworkHandler _networkHandler;
  final SharedPreferencesManager _sharedPreferencesManager;

  SessionApi(this._iSessionConverter, this._networkHandler,
      this._iUserConverter, this._sharedPreferencesManager);

  @override
  Future<UserModel> login(LoginModel loginModel) async {
    final body = jsonEncode(_iSessionConverter.toJsonLoginModel(loginModel));
    final res = await _networkHandler.post(path: Endpoint.login, body: body);
    if (res.statusCode == RemoteConstants.code_success) {
      final token = res.headers["authorization"];
      final refreshToken = res.headers["refreshtoken"];
      _sharedPreferencesManager.setAccessToken(token);
      _sharedPreferencesManager.setRefreshToken(refreshToken);
      return _iUserConverter
          .fromJson(json.decode(res.body)[RemoteConstants.result]);
    } else
      throw serverException(res);
  }

  @override
  Future<int> logout() async {
    final res = await _networkHandler.post(
        path: Endpoint.logout, doRefreshToken: false);
    if (res.statusCode == RemoteConstants.code_success)
      return RemoteConstants.code_success;
    else
      throw serverException(res);
  }

  @override
  Future<bool> validateToken() async {
    String token = await _sharedPreferencesManager.getAccessToken();
    token = token.startsWith("Bearer ") ? token.split("Bearer ")[1] : token;
    final jsonValidateToken = _iSessionConverter
        .toJsonValidateTokenModel(ValidateTokenModel(token: token));
    final res = await _networkHandler.post(
        path: Endpoint.validate_token, body: jsonEncode(jsonValidateToken));
    if (res.statusCode == RemoteConstants.code_success)
      return true;
    else
      throw serverException(res);
  }
}
