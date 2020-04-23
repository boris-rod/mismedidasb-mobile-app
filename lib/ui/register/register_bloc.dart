import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'dart:ui' as ui;

class RegisterBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IAccountRepository _iAccountRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  RegisterBloC(this._iAccountRepository, this._sharedPreferencesManager);

  BehaviorSubject<bool> _registerController = new BehaviorSubject();

  Stream<bool> get registerResult => _registerController.stream;

  BehaviorSubject<bool> _confirmationController = new BehaviorSubject();

  Stream<bool> get confirmedResult => _confirmationController.stream;

  String currentPassword = "";

  void register(String userName, String email, String password,
      String confirmPassword) async {
    isLoading = true;
    String locale = await _sharedPreferencesManager.getLanguageCode();

    final model = RegisterModel(
        fullName: userName,
        email: email,
        password: password,
        confirmationPassword: confirmPassword,
        language: locale);

//    print(model.toString());
//    Future.delayed(Duration(seconds: 2), (){
//      isLoading = false;
//    });
    final res = await _iAccountRepository.register(model);

    if (res is ResultSuccess<int>) {
      _registerController.sinkAddSafe(true);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void activateAccount(String email, String password, String code) async {
    isLoading = true;
    final res = await _iAccountRepository.confirmRegister(
        ActivationAccountModel(email: email, code: int.tryParse(code) ?? -1));
    if (res is ResultSuccess<int>) {
      await _sharedPreferencesManager.setUserEmail(email);
      await _sharedPreferencesManager.setPassword(password);
      await _sharedPreferencesManager.setSaveCredentials(false);

      _confirmationController.sinkAddSafe(true);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void resendCode(String email) async {
    isLoading = true;
    final res = await _iAccountRepository.resendCode(email);
    if (res is ResultSuccess<int>) {
      Fluttertoast.showToast(
          msg: R.string.checkEmail, toastLength: Toast.LENGTH_LONG);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _registerController.close();
    _confirmationController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
