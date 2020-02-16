import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_api.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';

class PollRepository extends BaseRepository implements IPollRepository {
  final IPollApi _iPollApi;

  PollRepository(this._iPollApi);

  @override
  Future<Result<List<PollModel>>> getPollList(int healthConceptId) async {
    try {
      final result = await _iPollApi.getPollList(healthConceptId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
