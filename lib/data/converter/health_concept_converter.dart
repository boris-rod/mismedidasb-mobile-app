import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_converter.dart';

class HealthConceptConverter implements IHealthConceptConverter {
  @override
  HealthConceptModel fromJson(Map<String, dynamic> json) {
    return HealthConceptModel(
      id: json[RemoteConstants.id],
      title: json[RemoteConstants.title],
      description: json[RemoteConstants.description],
      codeName: json[RemoteConstants.code_name],
      image:  json[RemoteConstants.image],
      instructions: json[RemoteConstants.instructions]
    );
  }
}
