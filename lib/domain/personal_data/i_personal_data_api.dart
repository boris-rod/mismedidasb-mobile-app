import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';

abstract class IPersonalDataApi {
  Future<List<PersonalDataModel>> getPersonalData();
}
