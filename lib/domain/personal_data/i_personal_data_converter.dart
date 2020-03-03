import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

abstract class IPersonalDataConverter {
  PersonalDataModel fromJson(Map<String, dynamic> json);

  HealthResult fromJsonHealthResult(Map<String, dynamic> json);

  Map<String, dynamic> toJsonHealthResult(HealthResult model);
}
