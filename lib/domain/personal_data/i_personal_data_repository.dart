import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

abstract class IPersonalDataRepository {
  Future<Result<List<PersonalDataModel>>> getPersonalData();

  Future<HealthResult> getHealthResult();

  Future<bool> saveHealthResult(HealthResult model);
}
