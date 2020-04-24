import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_converter.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';

class LegacyConverter implements ILegacyConverter {
  @override
  LegacyModel fromJson(Map<String, dynamic> json) {
    return LegacyModel(
      id: json[RemoteConstants.id],
      content: json[RemoteConstants.content],
      contentType: json[RemoteConstants.content_type],
      contentTypeId: json[RemoteConstants.content_type_id],
    );
  }
}
