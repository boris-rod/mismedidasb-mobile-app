import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';

abstract class IAccountApi {
  Future<int> register(RegisterModel registerModel);

  Future<int> confirmRegister(ActivationAccountModel activationAccountModel);

  Future<int> resendCode(String email);

  Future<int> recoverPassword(String email);

  Future<bool> changePassword(ChangePasswordModel changePasswordModel);

  Future<List<SettingAPIModel>> getSettings();

  Future<bool> saveSettings(List<SettingAPIModel> list);

  Future<bool> removeAccount(bool softDeletion);
}
