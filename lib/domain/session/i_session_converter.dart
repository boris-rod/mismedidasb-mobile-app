import 'package:mismedidasb/domain/session/session_model.dart';

abstract class ISessionConverter {
  Map<String, dynamic> toJsonLoginModel(LoginModel loginModel);

  Map<String, dynamic> toJsonValidateTokenModel(
      ValidateTokenModel validateTokenModel);
}
