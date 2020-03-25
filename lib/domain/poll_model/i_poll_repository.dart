import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';

abstract class IPollRepository {
  Future<Result<List<PollModel>>> getPollsByConcept(int conceptId);

  Future<Result<String>> setPollResult(List<PollModel> polls);

}
