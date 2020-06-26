import 'dart:io';

import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserApi {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile(UserModel userModel);

  Future<bool> uploadAvatar(File photo);

  Future<bool> invite(List<String> emails);

  Future<ScoreModel> getScores();

}
