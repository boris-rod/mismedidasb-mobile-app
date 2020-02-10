import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<UserModel>> updateProfile();

  Future<Result<bool>> uploadAvatar();
}
