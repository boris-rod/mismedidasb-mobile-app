import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

class RecoverPasswordBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IAccountRepository _iAccountRepository;

  BehaviorSubject<bool> _recoverController = new BehaviorSubject();

  RecoverPasswordBloC(this._iAccountRepository);

  Stream<bool> get recoverResult => _recoverController.stream;

  void recoverPassword(String email) async {
    isLoading = true;
    final res = await _iAccountRepository.recoverPassword(email);
    if (res is ResultSuccess<int>) {
      _recoverController.sinkAddSafe(true);
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  @override
  void dispose() {
    _recoverController.close();
  }
}
