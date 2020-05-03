import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/answer/i_answer_converter.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class QuestionConverter implements IQuestionConverter {
  final IAnswerConverter _iAnswerConverter;

  QuestionConverter(this._iAnswerConverter);

  @override
  QuestionModel fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        id: json[RemoteConstants.id],
        pollId: json[RemoteConstants.poll_id],
        order: json[RemoteConstants.order],
        title: json[RemoteConstants.title],
        lastAnswer: json[RemoteConstants.last_answers],
        answers: (json[RemoteConstants.answers] as List<dynamic>)
            .map((model) => _iAnswerConverter.fromJson(model))
            .toList());
  }

  @override
  Map<String, dynamic> toQuestionResultMap(QuestionResultModel model) {
    return {
      RemoteConstants.question_id : model.questionId,
      RemoteConstants.answer_id : model.answerId
    };
  }
}
