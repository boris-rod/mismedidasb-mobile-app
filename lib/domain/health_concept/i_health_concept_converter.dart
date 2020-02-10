import 'package:mismedidasb/domain/health_concept/health_concept.dart';

abstract class IHealthConceptConverter {
  HealthConceptModel fromJson(Map<String, dynamic> json);
}
