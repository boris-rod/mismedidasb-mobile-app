import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IPollRepository {
  Future<Result<List<PollModel>>> getPollsByConcept(int conceptId);

  Future<Result<PollResponseModel>> setPollResult(List<PollModel> polls);

  Future<Result<List<SoloQuestionModel>>> getSoloQuestions();

  Future<Result<PollResponseModel>> postSoloQuestion(SoloAnswerCreateModel model);

}
