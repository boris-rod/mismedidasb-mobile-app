import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class LoginBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _userRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  LoginBloC(this._userRepository, this._sharedPreferencesManager);

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

  void login() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 2), (){
      _loginController.sinkAddSafe(UserModel());
      isLoading = false;
    });
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
