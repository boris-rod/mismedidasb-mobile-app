import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/answer/i_answer_converter.dart';

class AnswerConverter implements IAnswerConverter {
  @override
  AnswerModel fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json[RemoteConstants.id],
      questionId: json[RemoteConstants.question_id],
      title: json[RemoteConstants.title],
      weight: json[RemoteConstants.weight],
      order: json[RemoteConstants.order],
    );
  }
}
