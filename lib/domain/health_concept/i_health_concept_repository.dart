import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';

abstract class IHealthConceptRepository {
  Future<Result<List<HealthConceptModel>>> getHealthConceptList();
}
