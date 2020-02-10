import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';

class PollConverter implements IPollConverter{
  @override
  PollModel fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json[RemoteConstants.id],
      name: json[RemoteConstants.name],
      description: json[RemoteConstants.description],
      codeName: json[RemoteConstants.code_name],
      conceptId: json[RemoteConstants.concept_id],
    );
  }

}