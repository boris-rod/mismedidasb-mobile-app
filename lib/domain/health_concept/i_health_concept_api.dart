import 'package:mismedidasb/domain/health_concept/health_concept.dart';

abstract class IHealthConceptApi {
  Future<List<HealthConceptModel>> getHealthConceptList();
}
