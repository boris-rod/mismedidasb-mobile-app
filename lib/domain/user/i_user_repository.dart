import 'dart:io';

import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<AppVersionModel>> getAppVersion();

  Future<Result<UserModel>> updateProfile(UserModel userModel);

  Future<Result<bool>> uploadAvatar(File photo);

  Future<Result<bool>> invite(List<String> emails);

  Future<Result<ScoreModel>> getScores();

  Future<Result<bool>> stripePaymentAction();

  Future<Result<SoloQuestionStatsModel>> getSoloQuestionStats(int daysAgo);

  Future<Result<UsernameSuggestionModel>> usernameValidation(
      int userId, String email, String username, String fullName);
}
