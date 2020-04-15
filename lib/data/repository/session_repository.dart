import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';

class SessionRepository extends BaseRepository implements ISessionRepository {
  final ISessionApi _iSessionApi;
  final SharedPreferencesManager _sharedPreferencesManager;
  final IFCMFeature _fcmFeature;

  SessionRepository(
      this._iSessionApi, this._sharedPreferencesManager, this._fcmFeature);

  @override
  Future<Result<UserModel>> login(
      LoginModel loginModel, bool saveCredentials) async {
    try {
      final result = await _iSessionApi.login(loginModel);
      _sharedPreferencesManager.setUserEmail(result.email);
      _sharedPreferencesManager.setActivateAccount(result.statusId);
      _sharedPreferencesManager.setDailyKCal(result.dailyKCal);
      _sharedPreferencesManager.setIMC(result.imc);
      if (saveCredentials) {
        _sharedPreferencesManager.setUserId(result.id);
        _sharedPreferencesManager.setPassword(loginModel.password);
      }
      await _fcmFeature.refreshToken();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> logout() async {
    try {
      _fcmFeature.deactivateToken();
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
