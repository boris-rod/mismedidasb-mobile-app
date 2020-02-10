import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_api.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';

class PersonalDataRepository implements IPersonalDataRepository {
  final IPersonalDataApi _iPersonalDataApi;

  PersonalDataRepository(this._iPersonalDataApi);

  @override
  Future<Result<List<PersonalDataModel>>> getPersonalData() async {
    try {
      final result = await _iPersonalDataApi.getPersonalData();
      return Result.success(value: result);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }
}
