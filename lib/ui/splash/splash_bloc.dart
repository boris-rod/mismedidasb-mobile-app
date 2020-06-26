import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_global.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SplashBloC extends BaseBloC {
  final ISessionRepository _iSessionRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  SplashBloC(this._iSessionRepository, this._sharedPreferencesManager);

  BehaviorSubject<bool> _navigateController = new BehaviorSubject();

  Stream<bool> get navigateResult => _navigateController.stream;

  void shouldNavigateToLogin() async {

    final planiId = await _sharedPreferencesManager.getIntValue(SharedKey.planiId);
    Injector.instance.planiId = planiId;

    final firstUse = await _sharedPreferencesManager
        .getBoolValue(SharedKey.firstUse, defValue: true);
    if (firstUse) {
      await _sharedPreferencesManager.init();
      await _sharedPreferencesManager.setBoolValue(SharedKey.firstUse, false);
      _navigateController.sinkAddSafe(true);
    } else {
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
          final res = await _iSessionRepository.validateToken();
          if (res is ResultSuccess<bool>)
            _navigateController.sink.add(!res.value);
          else
            _navigateController.sinkAddSafe(true);
        }
      } else {
        _navigateController.sinkAddSafe(true);
      }
    }
  }

  void resolveInitialSettings(SettingModel settingModel) async {
    String locale = await _sharedPreferencesManager.getLanguageCode();
    if (locale.isEmpty ||
        !["es", "en", "it"].contains(settingModel.languageCode)) {
      settingModel.languageCode = "es";
    } else {
      settingModel.languageCode = locale;
    }
    await _sharedPreferencesManager.setLanguageCode(settingModel.languageCode);
    languageCodeController.sinkAddSafe(settingModel);
  }

  @override
  void dispose() {
    _navigateController.close();
  }
}
