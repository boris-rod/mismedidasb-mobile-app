import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class ChangePasswordBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  final IAccountRepository _iAccountRepository;

  ChangePasswordBloC(this._sharedPreferencesManager, this._iAccountRepository);

  BehaviorSubject<String> _initController = new BehaviorSubject();

  Stream<String> get initResult => _initController.stream;

  BehaviorSubject<bool> _changeController = new BehaviorSubject();

  Stream<bool> get changeResult => _changeController.stream;

  void initView() async {
    final currentPassword = await _sharedPreferencesManager.getPassword();
    _initController.sinkAddSafe(currentPassword);
  }

  void changePassword(
      String oldPass, String newPass, String confirmPass) async {
    isLoading = true;
    final res = await _iAccountRepository.changePassword(ChangePasswordModel(
        oldPassword: oldPass,
        newPassword: newPass,
        confirmPassword: confirmPass));
    if (res is int){
      await _sharedPreferencesManager.setPassword(newPass);
      _changeController.sinkAddSafe(true);
    }
    else
      showErrorMessage(res);
    isLoading = false;
  }

  @override
  void dispose() {
    _initController.close();
    _changeController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
