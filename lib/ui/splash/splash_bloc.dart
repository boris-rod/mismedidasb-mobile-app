import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SplashBloC extends BaseBloC{
  final ISessionRepository _iSessionRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  SplashBloC(this._iSessionRepository, this._sharedPreferencesManager);

  BehaviorSubject<bool> _navigateController = new BehaviorSubject();

  Stream<bool> get navigateResult => _navigateController.stream;

  void shouldNavigateToLogin() async {

    final bool saveCredentials =
    await _sharedPreferencesManager.getSaveCredentials();
    if (saveCredentials) {
      final String email = await _sharedPreferencesManager.getUserEmail();
      final String password = await _sharedPreferencesManager.getPassword();

      final String accessToken =
      await _sharedPreferencesManager.getAccessToken();
      final String refreshToken =
      await _sharedPreferencesManager.getRefreshToken();

      if (email.isEmpty ||
          password.isEmpty ||
          accessToken.isEmpty ||
          refreshToken.isEmpty)
        _navigateController.sinkAddSafe(true);
      else {
        Future.delayed(Duration(seconds: 1), (){
          _navigateController.sinkAddSafe(true);
        });
//        final res = await _iSessionRepository.validateToken();
//        if (res is ResultSuccess<bool>) _navigateController.sink.add(!res.value);
//        else
//          _navigateController.sinkAddSafe(true);
      }
    } else {
      _navigateController.sinkAddSafe(true);
    }
  }

  @override
  void dispose() {
    _navigateController.close();
  }

}