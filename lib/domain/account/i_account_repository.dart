import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';

abstract class IAccountRepository {
  Future<Result<int>> register(RegisterModel registerModel);

  Future<Result<int>> confirmRegister(
      ActivationAccountModel activationAccountModel);

  Future<Result<int>> resendCode(String email);

  Future<Result<int>> recoverPassword(String email);

  Future<Result<bool>> changePassword(ChangePasswordModel changePasswordModel);

  Future<Result<SettingModel>> getSettings();

  Future<Result<bool>> saveSettings(SettingModel model);
}
