import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';

abstract class IPersonalDataRepository{
    Future<Result<List<PersonalDataModel>>> getPersonalData();
}