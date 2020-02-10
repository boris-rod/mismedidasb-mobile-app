import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';

abstract class IPersonalDataConverter{
  PersonalDataModel fromJson(Map<String, dynamic> json);
}