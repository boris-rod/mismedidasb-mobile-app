import 'dart:io';

import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserApi {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile(UserModel userModel);

  Future<UserModel> uploadAvatar(File photo);
}
