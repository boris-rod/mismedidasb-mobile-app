import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IQuestionApi {
  Future<List<QuestionModel>> getQuestionList(int pollId);
}
