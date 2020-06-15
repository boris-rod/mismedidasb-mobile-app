import 'package:mismedidasb/domain/poll_model/poll_model.dart';

abstract class IPollApi {
  Future<List<PollModel>> getPollsByConcept(int conceptId);

  Future<String> setPollResult(List<PollResultModel> list);

  Future<String> setSoloPollResult(List<PollResultModel> list);
}
