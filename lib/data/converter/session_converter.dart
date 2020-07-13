import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/session/i_session_converter.dart';
import 'package:mismedidasb/domain/session/session_model.dart';

class SessionConverter implements ISessionConverter {
  @override
  Map<String, dynamic> toJsonLoginModel(LoginModel loginModel) {
    return {
      RemoteConstants.email: loginModel.email,
      RemoteConstants.password: loginModel.password,
      RemoteConstants.timezone: loginModel.timezone,
      RemoteConstants.timezoneOffset: loginModel.userTimeZoneOffset
    };
  }

  @override
  Map<String, dynamic> toJsonValidateTokenModel(
      ValidateTokenModel validateTokenModel) {
    return {RemoteConstants.token: validateTokenModel.token};
  }
}
