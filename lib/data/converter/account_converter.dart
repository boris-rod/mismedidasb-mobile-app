import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/account/i_account_converter.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';

class AccountConverter implements IAccountConverter {
  @override
  Map<String, dynamic> toJsonActivationAccountModel(
      ActivationAccountModel activationAccountModel) {
    return {
      RemoteConstants.code: activationAccountModel.code,
      RemoteConstants.email: activationAccountModel.email
    };
  }

  @override
  Map<String, dynamic> toJsonChangePasswordModel(
      ChangePasswordModel changePasswordModel) {
    return {
      RemoteConstants.old_password: changePasswordModel.oldPassword,
      RemoteConstants.new_password: changePasswordModel.newPassword,
      RemoteConstants.confirm_password: changePasswordModel.confirmPassword
    };
  }

  @override
  Map<String, dynamic> toJsonRegisterModel(RegisterModel registerModel) {
    return {
      RemoteConstants.email: registerModel.email,
      RemoteConstants.full_name: registerModel.fullName,
      RemoteConstants.password: registerModel.password,
      RemoteConstants.confirmation_password: registerModel.confirmationPassword,
      RemoteConstants.language: registerModel.language
    };
  }

  @override
  SettingAPIModel fromJsonSettingAPIModel(Map<String, dynamic> json) {
    return SettingAPIModel(
        settingId: json["settingId"],
        setting: json["setting"],
        value: json["value"]);
  }

  @override
  Map<String, dynamic> toJsonSettingModel(SettingAPIModel registerModel) {
    return {"settingId": registerModel.settingId, "value": registerModel.value};
  }
}
