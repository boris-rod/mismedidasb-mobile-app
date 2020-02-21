import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class ISessionApi {
  Future<bool> validateToken();

  Future<UserModel> login(LoginModel loginModel);

  Future<int> logout();
}
