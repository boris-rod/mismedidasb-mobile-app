import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_api.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class PollRepository extends BaseRepository implements IPollRepository {
  final IPollApi _iPollApi;

  PollRepository(this._iPollApi);

  @override
  Future<Result<List<PollModel>>> getPollsByConcept(int conceptId) async {
    try {
      final result = await _iPollApi.getPollsByConcept(conceptId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<String>> setPollResult(List<PollModel> polls) async {
    try {
      List<PollResultModel> list = [];
      polls.forEach((poll) {
        PollResultModel pollResult =
            PollResultModel(pollId: poll.id, questionsResults: []);
        poll.questions.forEach((quest) {
          pollResult.questionsResults.add(QuestionResultModel(
              questionId: quest.id,
              answerId: quest.selectedAnswerId == -1
                  ? quest.answers[0].id
                  : quest.selectedAnswerId));
        });
        list.add(pollResult);
      });
      final result = await _iPollApi.setPollResult(list);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
