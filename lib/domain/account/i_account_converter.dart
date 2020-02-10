import 'package:mismedidasb/domain/account/account_model.dart';

abstract class IAccountConverter{
  Map<String, dynamic> toJsonRegisterModel(RegisterModel registerModel);
  Map<String, dynamic> toJsonActivationAccountModel(ActivationAccountModel activationAccountModel);
  Map<String, dynamic> toJsonChangePasswordModel(ChangePasswordModel changePasswordModel);
}