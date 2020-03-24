import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_converter.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';

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
        readOnlyData: json[RemoteConstants.read_only_data],
        conceptId: json[RemoteConstants.concept_id],
        conceptModel:
            _iHealthConceptConverter.fromJson(json[RemoteConstants.concept]));
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
}
