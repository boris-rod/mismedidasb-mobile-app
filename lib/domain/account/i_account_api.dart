import 'package:mismedidasb/domain/account/account_model.dart';

abstract class IAccountApi {
  Future<int> register(RegisterModel registerModel);

  Future<int> confirmRegister(ActivationAccountModel activationAccountModel);

  Future<int> resendCode(String email);

  Future<int> recoverPassword(String email);

  Future<int> changePassword(ChangePasswordModel changePasswordModel);
}
