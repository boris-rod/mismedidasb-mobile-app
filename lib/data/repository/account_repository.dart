import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_api.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';

class AccountRepository extends BaseRepository implements IAccountRepository {
  final IAccountApi _accountApi;

  AccountRepository(this._accountApi);

  @override
  Future<Result<bool>> changePassword(
      ChangePasswordModel changePasswordModel) async {
    try {
      final result = await _accountApi.changePassword(changePasswordModel);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> confirmRegister(
      ActivationAccountModel activationAccountModel) async {
    try {
      final result = await _accountApi.confirmRegister(activationAccountModel);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> recoverPassword(String email) async {
    try {
      final result = await _accountApi.recoverPassword(email);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> register(RegisterModel registerModel) async {
    try {
      final result = await _accountApi.register(registerModel);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<int>> resendCode(String email) async {
    try {
      final result = await _accountApi.resendCode(email);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<SettingModel>> getSettings() async {
    try {
      final result = await _accountApi.getSettings();
      final SettingModel model =
          SettingModel(languageCode: "es", languageCodeId: 0);

      final obj = result.firstWhere((m) => m.setting == "language", orElse: () {
        return null;
      });
      if (obj != null) {
        model.languageCode = obj.value.toLowerCase();
        model.languageCodeId = obj.settingId;
      }
      return Result.success(value: model);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> saveSettings(SettingModel model) async {
    final language = SettingAPIModel(
        settingId: model.languageCodeId, value: model.languageCode);
    try {
      final result = await _accountApi.saveSettings([language]);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> removeAccount(bool softDeletion) async {
    try {
      final result = await _accountApi.removeAccount(softDeletion);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
