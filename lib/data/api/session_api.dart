import 'dart:convert';

import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_converter.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class SessionApi implements ISessionApi {
  final ISessionConverter _iSessionConverter;
  final IUserConverter _iUserConverter;
  final NetworkHandler _networkHandler;

  SessionApi(
      this._iSessionConverter, this._networkHandler, this._iUserConverter);

  @override
  Future<UserModel> login(LoginModel loginModel) async {
    final body = jsonEncode(_iSessionConverter.toJsonLoginModel(loginModel));
    final res = await _networkHandler.post(path: Endpoint.login, body: body);
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJson(json.decode(res.body)[RemoteConstants.result]);
    else
      throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }

  @override
  Future<int> logout() async {
    final res = await _networkHandler.post(path: Endpoint.login);
    if (res.statusCode == RemoteConstants.code_success)
      return RemoteConstants.code_success;
    else
      throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }

  @override
  Future<bool> validateToken(String token) async {
    final res = await _networkHandler.post(path: Endpoint.validate_token);
    if (res.statusCode == RemoteConstants.code_success)
      return true;
    else
      throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }
}
