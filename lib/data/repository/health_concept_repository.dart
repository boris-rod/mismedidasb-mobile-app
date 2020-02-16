import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_api.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_repository.dart';

class HealthConceptRepository extends BaseRepository implements IHealthConceptRepository{
  final IHealthConceptApi _iHealthConceptApi;

  HealthConceptRepository(this._iHealthConceptApi);

  @override
  Future<Result<List<HealthConceptModel>>> getHealthConceptList() async{
    try {
      final result = await _iHealthConceptApi.getHealthConceptList();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

}