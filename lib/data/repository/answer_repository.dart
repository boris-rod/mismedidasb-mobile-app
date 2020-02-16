import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/answer/i_answer_api.dart';
import 'package:mismedidasb/domain/answer/i_answer_repository.dart';

class AnswerRepository extends BaseRepository implements IAnswerRepository {
  final IAnswerApi _iAnswerApi;

  AnswerRepository(this._iAnswerApi);

  @override
  Future<Result<List<AnswerModel>>> getAnswerList(int questionId) async {
    try {
      final result = await _iAnswerApi.getAnswerList(questionId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
