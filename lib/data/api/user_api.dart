import 'dart:convert';
import 'dart:io';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserApi extends BaseApi implements IUserApi {
  final IUserConverter _iUserConverter;
  final NetworkHandler _networkHandler;

  UserApi(this._iUserConverter, this._networkHandler);

  @override
  Future<UserModel> getProfile() async {
    final res = await _networkHandler.get(path: Endpoint.profile,);
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJson(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<UserModel> updateProfile(UserModel userModel) async {
    final body = _iUserConverter.toJson(userModel);
    final res = await _networkHandler.post(
        path: Endpoint.update_profile, body: jsonEncode(body));
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJson(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<UserModel> uploadAvatar(File photo) async {
    final res = await _networkHandler.postFile(
      path: Endpoint.upload_avatar,
      files: photo,
    );
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter.fromJson(res.data[RemoteConstants.result]);
    else
      throw null;
  }
}
