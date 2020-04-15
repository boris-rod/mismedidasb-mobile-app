import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_api.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

class PersonalDataRepository extends BaseRepository
    implements IPersonalDataRepository {
  final IPersonalDataApi _iPersonalDataApi;
  final IPersonalDataDao _iPersonalDataDao;

  PersonalDataRepository(this._iPersonalDataApi, this._iPersonalDataDao);

  @override
  Future<Result<List<PersonalDataModel>>> getPersonalData() async {
    try {
      final result = await _iPersonalDataApi.getPersonalData();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

//  @override
//  Future<HealthResult> getHealthResult() async{
//    try {
//      final result = await _iPersonalDataDao.getHealthResult();
//      return result ;
//    } catch (ex) {
//      return HealthResult();
//    }
//  }

//  @override
//  Future<bool> saveHealthResult(HealthResult model) async{
//    try {
//      final result = await _iPersonalDataDao.saveHealthResult(model);
//      return true;
//    } catch (ex) {
//      return false;
//    }
//  }
}
