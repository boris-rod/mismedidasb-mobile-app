import 'dart:io';

import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserApi {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile(UserModel userModel);

  Future<bool> uploadAvatar(File photo);

  Future<bool> invite(List<String> emails);

  Future<ScoreModel> getScores();

  Future<UsernameSuggestionModel> usernameValidation(
      int userId, String email, String username, String fullName);
}
