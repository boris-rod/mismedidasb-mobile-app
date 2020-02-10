import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class QuestionConverter implements IQuestionConverter{
  @override
  QuestionModel fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json[RemoteConstants.id],
      title: json[RemoteConstants.title],
      pollId: json[RemoteConstants.poll_id],
      order: json[RemoteConstants.order],
    );
  }

}