import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class ISessionRepository{
    Future<Result<bool>> validateToken();

    Future<Result<UserModel>> login(LoginModel loginModel, bool saveCredentials);

    Future<Result<int>> logout();
}