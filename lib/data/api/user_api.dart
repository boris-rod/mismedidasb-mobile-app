import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserApi implements IUserApi {
  final IUserConverter _iUserConverter;
  final NetworkHandler _networkHandler;

  UserApi(this._iUserConverter, this._networkHandler);

  @override
  Future<UserModel> getProfile() {
    // TODO: implement getProfile
    return null;
  }

  @override
  Future<UserModel> updateProfile() {
    // TODO: implement updateProfile
    return null;
  }

  @override
  Future<bool> uploadAvatar() {
    // TODO: implement uploadAvatar
    return null;
  }
}
