import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IQuestionRepository {
  Future<Result<List<QuestionModel>>> getQuestionList(int pollId);
}
