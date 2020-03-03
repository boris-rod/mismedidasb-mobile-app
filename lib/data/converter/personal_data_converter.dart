import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_converter.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

class PersonalDataConverter implements IPersonalDataConverter {
  @override
  PersonalDataModel fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      id: json[RemoteConstants.id],
      name: json[RemoteConstants.name],
      measureUnit: json[RemoteConstants.measure_unit],
      codeName: json[RemoteConstants.code_name],
      order: json[RemoteConstants.order],
      type: json[RemoteConstants.type],
      typeId: json[RemoteConstants.type_id],
    );
  }

  @override
  HealthResult fromJsonHealthResult(Map<String, dynamic> json) {
    return HealthResult(
        imc: json["imc"],
        tmb: json["tmb"],
        kCal: json["kCal"],
        result: json["result"]);
  }

  @override
  Map<String, dynamic> toJsonHealthResult(HealthResult model) {
    return {
      "imc": model.imc,
      "tmb": model.tmb,
      "kCal": model.kCal,
      "result": model.result
    };
  }
}
