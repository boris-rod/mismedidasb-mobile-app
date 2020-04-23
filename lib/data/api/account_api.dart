import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_api.dart';
import 'package:mismedidasb/domain/account/i_account_converter.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';

class AccountApi extends BaseApi implements IAccountApi {
  final IAccountConverter _iAccountConverter;
  final NetworkHandler _networkHandler;

  AccountApi(this._iAccountConverter, this._networkHandler);

  @override
  Future<bool> changePassword(ChangePasswordModel changePasswordModel) async {
    final body = jsonEncode(
        _iAccountConverter.toJsonChangePasswordModel(changePasswordModel));
    final res =
        await _networkHandler.post(path: Endpoint.change_password, body: body);
    if (res.statusCode == RemoteConstants.code_success)
      return true;
    else
      throw serverException(res);
  }

  @override
  Future<int> confirmRegister(
      ActivationAccountModel activationAccountModel) async {
    final body = jsonEncode(_iAccountConverter
        .toJsonActivationAccountModel(activationAccountModel));
    final res = await _networkHandler.post(
        path: Endpoint.activation_account, body: body);
    if (res.statusCode == RemoteConstants.code_success)
      return RemoteConstants.code_success;
    else
      throw serverException(res);
  }

  @override
  Future<int> recoverPassword(String email) async {
    final res = await _networkHandler.post(
        path: Endpoint.recover_password, params: "?email=$email");
    if (res.statusCode == RemoteConstants.code_success)
      return RemoteConstants.code_success;
    else
      throw serverException(res);
  }

  @override
  Future<int> register(RegisterModel registerModel) async {
    final body =
        jsonEncode(_iAccountConverter.toJsonRegisterModel(registerModel));
    final res = await _networkHandler.post(path: Endpoint.register, body: body);
    if (res.statusCode == RemoteConstants.code_success_created)
      return RemoteConstants.code_success_created;
    else
      throw serverException(res);
  }

  @override
  Future<int> resendCode(String email) async {
    final res = await _networkHandler.post(
        path: Endpoint.resend_code, params: "?email=$email");
    if (res.statusCode == RemoteConstants.code_success)
      return RemoteConstants.code_success;
    throw serverException(res);
  }

  @override
  Future<List<SettingAPIModel>> getSettings() async {
    final res = await _networkHandler.get(
      path: Endpoint.save_settings,
    );
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l
          .map((model) => _iAccountConverter.fromJsonSettingAPIModel(model))
          .toList();
    }
    throw serverException(res);
  }

  @override
  Future<bool> saveSettings(List<SettingAPIModel> list) async {
    final map = list
        .map((model) => _iAccountConverter.toJsonSettingModel(model))
        .toList();
    final body = jsonEncode(map);
    final res =
        await _networkHandler.post(path: Endpoint.save_settings, body: body);
    if (res.statusCode == RemoteConstants.code_success) return true;
    throw serverException(res);
  }
}
