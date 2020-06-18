import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_converter.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class PollConverter implements IPollConverter {
  final IHealthConceptConverter _iHealthConceptConverter;
  final IQuestionConverter _iQuestionConverter;

  PollConverter(this._iHealthConceptConverter, this._iQuestionConverter);

  @override
  PollModel fromJson(Map<String, dynamic> json) {
    return PollModel(
        id: json[RemoteConstants.id],
        name: json[RemoteConstants.name],
        description: json[RemoteConstants.description],
        order: json[RemoteConstants.order],
        isReadOnly: json[RemoteConstants.is_read_only],
        htmlContent: json[RemoteConstants.html_content],
        conceptId: json[RemoteConstants.concept_id],
        conceptModel:
            _iHealthConceptConverter.fromJson(json[RemoteConstants.concept]),
        tips: (json[RemoteConstants.tips] as List<dynamic>)
            .map((map) => fromJsonPollTipModel(map))
            .toList(),
        questions: (json[RemoteConstants.questions] as List<dynamic>)
            .map((map) => _iQuestionConverter.fromJson(map))
            .toList());
  }

  @override
  Map<String, dynamic> toPollResultMap(PollResultModel model) {
    return {
      RemoteConstants.poll_id: model.pollId,
      RemoteConstants.questions_results: model.questionsResults
          .map((model) => _iQuestionConverter.toQuestionResultMap(model))
          .toList()
    };
  }

  @override
  PollTipModel fromJsonPollTipModel(Map<String, dynamic> json) {
    return PollTipModel(
        id: json[RemoteConstants.id],
        pollId: json[RemoteConstants.poll_id],
        content: json[RemoteConstants.content],
        isActive: json[RemoteConstants.is_active],
        tipPositionString: json[RemoteConstants.tip_position_str],
        tipPosition: json[RemoteConstants.tip_position]);
  }

  @override
  SoloAnswerModel fromJsonSoloAnswerModel(Map<String, dynamic> json) {
    final SoloAnswerModel model = SoloAnswerModel(
      id: json["id"],
      soloQuestionId: json["soloQuestionId"],
      code: json["code"],
      title: json["title"],
      titleIT: json["titleIT"],
      titleEN: json["titleEN"],
      points: json["points"],
    );
    return model;
  }

  @override
  SoloQuestionModel fromJsonSoloQuestionModel(Map<String, dynamic> json) {
    final SoloQuestionModel model = SoloQuestionModel(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        titleIT: json["titleIT"],
        titleEN: json["titleEN"],
        allowCustomAnswer: json["allowCustomAnswer"],
        soloAnswers: (json["soloAnswers"] as List<dynamic>)
            .map((e) => fromJsonSoloAnswerModel(e))
            .toList());
    return model;
  }

  @override
  Map<String, dynamic> toJsonSoloAnswerCreateModel(
      SoloAnswerCreateModel model) {
    final map = {
      "questionCode": model.questionCode,
      "answerCode": model.answerCode,
      "answerValue": model.answerValue
    };
    return map;
  }

  @override
  PollResponseModel fromJsonPollResponse(Map<String, dynamic> json) {
    final PollResponseModel model = PollResponseModel(
        result: (json["result"] is List<dynamic>)
            ? List.from(json["result"])[0]
            : "",
        reward: json["reward"] != null ? fromJsonReward(json["reward"]) : RewardModel());
    return model;
  }

  @override
  RewardModel fromJsonReward(Map<String, dynamic> json) {
    final RewardModel model = RewardModel(
        id: json["id"],
        userId: json["userId"],
        rewardCategoryId: json["rewardCategoryId"],
        categoryId: json["categoryId"],
        category: json["category"],
        points: json["points"]);
    return model;
  }
}
