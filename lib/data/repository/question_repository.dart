import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/question/i_question_api.dart';
import 'package:mismedidasb/domain/question/i_question_repository.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class QuestionRepository extends BaseRepository implements IQuestionRepository {
  final IQuestionApi _iQuestionApi;

  QuestionRepository(this._iQuestionApi);

  @override
  Future<Result<List<QuestionModel>>> getQuestionList(int pollId) async {
    try {
      final result = await _iQuestionApi.getQuestionList(pollId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
