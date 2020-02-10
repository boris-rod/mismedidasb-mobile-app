import 'dart:convert';

import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_api.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';

class PollApi implements IPollApi {
  final IPollConverter _iPollConverter;
  final NetworkHandler _networkHandler;

  PollApi(this._iPollConverter, this._networkHandler);

  @override
  Future<List<PollModel>> getPollList(int healthConceptId) async {
    final res = await _networkHandler.get(
        path:
            "${Endpoint.health_concept}/$healthConceptId${Endpoint.health_concept_polls}");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = json.decode(res.body)[RemoteConstants.result];
      return l.map((model) => _iPollConverter.fromJson(model)).toList();
    }
    throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }
}
