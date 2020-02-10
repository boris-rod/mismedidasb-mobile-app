import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserRepository implements IUserRepository{
  final IUserApi _iUserApi;

  UserRepository(this._iUserApi);
  @override
  Future<Result<UserModel>> getProfile() {
    // TODO: implement getProfile
    return null;
  }

  @override
  Future<Result<UserModel>> updateProfile() {
    // TODO: implement updateProfile
    return null;
  }

  @override
  Future<Result<bool>> uploadAvatar() {
    // TODO: implement uploadAvatar
    return null;
  }

}