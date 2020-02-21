import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class SessionRepository extends BaseRepository implements ISessionRepository {
  final ISessionApi _iSessionApi;
  final SharedPreferencesManager _sharedPreferencesManager;

  SessionRepository(this._iSessionApi, this._sharedPreferencesManager);

  @override
  Future<Result<UserModel>> login(LoginModel loginModel, bool saveCredentials) async {
    try {
      final result = await _iSessionApi.login(loginModel);
      _sharedPreferencesManager.setUserEmail(result.email);
      if(saveCredentials){
        _sharedPreferencesManager.setUserId(result.id);
        _sharedPreferencesManager.setPassword(loginModel.password);
      }
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> logout() async {
    try {
      final result = await _iSessionApi.logout();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> validateToken() async {
    try {
      final result = await _iSessionApi.validateToken();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
