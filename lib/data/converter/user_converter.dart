import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserConverter implements IUserConverter {
  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[RemoteConstants.id],
      fullName: json[RemoteConstants.full_name],
      email: json[RemoteConstants.email],
      phone: json[RemoteConstants.phone],
      statusId: json[RemoteConstants.status_id],
      status: json[RemoteConstants.status],
      avatar: json[RemoteConstants.avatar],
      avatarMimeType: json[RemoteConstants.avatar_mime_type],
      role: json[RemoteConstants.role],
      roleId: json[RemoteConstants.role_id],
    );
  }
}
