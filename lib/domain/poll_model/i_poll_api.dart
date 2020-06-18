import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IPollApi {
  Future<List<PollModel>> getPollsByConcept(int conceptId);

  Future<PollResponseModel> setPollResult(List<PollResultModel> list);

  Future<List<SoloQuestionModel>> getSoloQuestions();

  Future<PollResponseModel> postSoloQuestion(SoloAnswerCreateModel model);
}
