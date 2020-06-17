import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

abstract class IPollConverter {
  PollResponseModel fromJsonPollResponse(Map<String, dynamic> json);

  RewardModel fromJsonReward(Map<String, dynamic> json);

  PollModel fromJson(Map<String, dynamic> json);

  SoloQuestionModel fromJsonSoloQuestionModel(Map<String, dynamic> json);

  SoloAnswerModel fromJsonSoloAnswerModel(Map<String, dynamic> json);

  PollTipModel fromJsonPollTipModel(Map<String, dynamic> json);

  Map<String, dynamic> toPollResultMap(PollResultModel model);

  Map<String, dynamic> toJsonSoloAnswerCreateModel(SoloAnswerCreateModel model);

}
