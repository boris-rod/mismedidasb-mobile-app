import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';

class SessionRepository extends BaseRepository implements ISessionRepository {
  final ISessionApi _iSessionApi;
  final SharedPreferencesManager _sharedPreferencesManager;
  final IFCMFeature _fcmFeature;
  final ILNM _ilnm;

  SessionRepository(this._iSessionApi, this._sharedPreferencesManager,
      this._fcmFeature, this._ilnm);

  @override
  Future<Result<UserModel>> login(
      LoginModel loginModel, bool saveCredentials) async {
    try {
      final result = await _iSessionApi.login(loginModel);
      _sharedPreferencesManager.setUserEmail(result.email);
      _sharedPreferencesManager.setStringValue(SharedKey.userName, result.username);
      _sharedPreferencesManager.setDailyKCal(result.dailyKCal);
      _sharedPreferencesManager.setIMC(result.imc);
      _sharedPreferencesManager
          .setFirstDateHealthResult(result.firstDateHealthResult);
      if (saveCredentials) {
        _sharedPreferencesManager.setIntValue(SharedKey.userId, result.id);
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
      _ilnm.cancelAll();
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
      await _fcmFeature.refreshToken();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
