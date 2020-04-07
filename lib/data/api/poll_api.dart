import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_api.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/res/R.dart';

class PollApi extends BaseApi implements IPollApi {
  final IPollConverter _iPollConverter;
  final NetworkHandler _networkHandler;

  PollApi(this._iPollConverter, this._networkHandler);

  @override
  Future<List<PollModel>> getPollsByConcept(int conceptId) async {
    final res = await _networkHandler.get(
        path: "${Endpoint.get_poll}/?conceptId=$conceptId");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l.map((model) => _iPollConverter.fromJson(model)).toList();
    }
    throw serverException(res);
  }

  @override
  Future<String> setPollResult(List<PollResultModel> list) async {
    final map =
        list.map((model) => _iPollConverter.toPollResultMap(model)).toList();
    final body = jsonEncode({"pollDatas": map});
    final res =
        await _networkHandler.post(path: Endpoint.set_polls_result, body: body);
    if (res.statusCode == RemoteConstants.code_success)
      return R.string.appValuesResultText;
    throw serverException(res);
  }
}
