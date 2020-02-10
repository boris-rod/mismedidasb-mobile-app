import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_api.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';

class AccountRepository implements IAccountRepository {
  final IAccountApi _accountApi;

  AccountRepository(this._accountApi);

  @override
  Future<Result<int>> changePassword(
      ChangePasswordModel changePasswordModel) async {
    try {
      final result = await _accountApi.changePassword(changePasswordModel);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> confirmRegister(
      ActivationAccountModel activationAccountModel) async {
    try {
      final result = await _accountApi.confirmRegister(activationAccountModel);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> recoverPassword(String email) async {
    try {
      final result = await _accountApi.recoverPassword(email);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> register(RegisterModel registerModel) async {
    try {
      final result = await _accountApi.register(registerModel);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> resendCode(String email) async {
    try {
      final result = await _accountApi.resendCode(email);
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }
}
