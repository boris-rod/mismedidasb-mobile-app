import 'dart:io';

import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<UserModel>> updateProfile(UserModel userModel);

  Future<Result<bool>> uploadAvatar(File photo);

  Future<Result<bool>> invite(List<String> emails);

  Future<Result<ScoreModel>> getScores();

}
