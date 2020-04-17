import 'dart:io';

import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserRepository extends BaseRepository implements IUserRepository {
  final IUserApi _iUserApi;

  UserRepository(this._iUserApi);

  @override
  Future<Result<UserModel>> getProfile() async {
    try {
      final result = await _iUserApi.getProfile();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<UserModel>> updateProfile(UserModel userModel) async {
    try {
      final result = await _iUserApi.updateProfile(userModel);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> uploadAvatar(File photo) async {
    try {
      final result = await _iUserApi.uploadAvatar(photo);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
