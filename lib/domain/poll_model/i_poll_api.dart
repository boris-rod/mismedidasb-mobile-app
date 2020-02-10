import 'package:mismedidasb/domain/poll_model/poll_model.dart';

abstract class IPollApi {
  Future<List<PollModel>> getPollList(int healthConceptId);
}
