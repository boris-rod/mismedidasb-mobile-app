import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class SessionRepository implements ISessionRepository {
  final ISessionApi _iSessionApi;

  SessionRepository(this._iSessionApi);

  @override
  Future<Result<UserModel>> login(LoginModel loginModel) async {
    try {
      final result = await _iSessionApi.login(loginModel);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> logout() async {
    try {
      final result = await _iSessionApi.logout();
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<bool>> validateToken(String token) async {
    try {
      final result = await _iSessionApi.validateToken(token);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }
}
