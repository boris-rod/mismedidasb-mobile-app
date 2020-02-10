import 'dart:convert';

import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_api.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_converter.dart';

class HealthConceptApi implements IHealthConceptApi {
  final IHealthConceptConverter _iHealthConceptConverter;
  final NetworkHandler _networkHandler;

  HealthConceptApi(this._iHealthConceptConverter, this._networkHandler);

  @override
  Future<List<HealthConceptModel>> getHealthConceptList() async {
    final res = await _networkHandler.get(path: Endpoint.health_concept);
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = json.decode(res.body)[RemoteConstants.result];
      return l
          .map((model) => _iHealthConceptConverter.fromJson(model))
          .toList();
    }
    throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }
}
