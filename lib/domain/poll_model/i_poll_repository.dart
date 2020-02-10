import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';

abstract class IPollRepository {
  Future<Result<List<PollModel>>> getPollList(int healthConceptId);
}
