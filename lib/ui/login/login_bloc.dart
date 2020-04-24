import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/common_db/i_common_repository.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

enum LOGIN_RESULT { HOME, CONFIRMATION_CODE, TERMS_COND }

class LoginBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IDishRepository _iDishRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final ISessionRepository _iSessionRepository;
  final ICommonRepository _iCommonRepository;

  LoginBloC(this._iDishRepository, this._sharedPreferencesManager,
      this._iSessionRepository, this._iCommonRepository);

  BehaviorSubject<LOGIN_RESULT> _loginController = new BehaviorSubject();

  Stream<LOGIN_RESULT> get loginResult => _loginController.stream;

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
    await _sharedPreferencesManager.setSaveCredentials(value);
    _saveCredentialsController.sinkAddSafe(value);
  }

  void login(String email, String password) async {
    isLoading = true;
    final saveCredentials =
        await _sharedPreferencesManager.getSaveCredentials();
    final previousUserId = await _sharedPreferencesManager.getUserId();

    final res = await _iSessionRepository.login(
        LoginModel(email: email, password: password), saveCredentials);
    if (res is ResultSuccess<UserModel>) {
      //Cleaning DB in case of different user login
      if (previousUserId != res.value.id) {
        await _iCommonRepository.cleanDB();
      }
      _sharedPreferencesManager.setTermsCond(res.value.termsAndConditionsAccepted);
      _loginController.sinkAddSafe(res.value.termsAndConditionsAccepted
          ? LOGIN_RESULT.HOME
          : LOGIN_RESULT.TERMS_COND);
    } else {
      if (res is ResultError && (res as ResultError).code == RemoteConstants.code_forbidden) {
        _loginController.sinkAddSafe(LOGIN_RESULT.CONFIRMATION_CODE);
      } else
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
