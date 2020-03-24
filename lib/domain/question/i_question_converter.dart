import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IQuestionConverter {
  QuestionModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toQuestionResultMap(QuestionResultModel model);
}
