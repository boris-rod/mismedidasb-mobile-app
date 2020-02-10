import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';

abstract class IAnswerRepository {
  Future<Result<List<AnswerModel>>> getAnswerList(int questionId);
}
