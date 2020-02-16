import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class LoginBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IUserRepository _userRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final ISessionRepository _iSessionRepository;

  LoginBloC(this._userRepository, this._sharedPreferencesManager,
      this._iSessionRepository);

  BehaviorSubject<UserModel> _loginController = new BehaviorSubject();

  Stream<UserModel> get loginResult => _loginController.stream;

  BehaviorSubject<UserCredentialsModel> _userInitController =
      new BehaviorSubject();

  Stream<UserCredentialsModel> get userInitResult => _userInitController.stream;

  Stream<bool> get saveCredentialsResult => _saveCredentialsController.stream;

  BehaviorSubject<bool> _saveCredentialsController = new BehaviorSubject();

  void initView() async {
    final UserCredentialsModel userCredentials = UserCredentialsModel();
    userCredentials.saveCredentials =
        await _sharedPreferencesManager.getSaveCredentials();
    userCredentials.email = await _sharedPreferencesManager.getUserEmail();
    userCredentials.password = await _sharedPreferencesManager.getPassword();
    _saveCredentialsController.sinkAddSafe(userCredentials.saveCredentials);
    _userInitController.sinkAddSafe(userCredentials);
  }

  void saveCredentials(bool value) async {
    (await userInitResult.first).saveCredentials = value;
    _saveCredentialsController.sinkAddSafe(value);
  }

  void login(String email, String password) async {
    isLoading = true;
    final res = await _iSessionRepository
        .login(LoginModel(email: email, password: password));
    if (res is ResultSuccess<UserModel>) {
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _loginController.close();
    _userInitController.close();
    _saveCredentialsController.close();

    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
