import 'dart:convert';

import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/answer/i_answer_api.dart';
import 'package:mismedidasb/domain/answer/i_answer_converter.dart';

class AnswerApi implements IAnswerApi {
  final IAnswerConverter _iAnswerConverter;
  final NetworkHandler _networkHandler;

  AnswerApi(this._iAnswerConverter, this._networkHandler);

  @override
  Future<List<AnswerModel>> getAnswerList(int questionId) async {
    final res = await _networkHandler.get(
        path: Endpoint.question,
        params: "?${RemoteConstants.question_id}=$questionId");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = json.decode(res.body)[RemoteConstants.result];
      return l.map((model) => _iAnswerConverter.fromJson(model)).toList();
    }
    throw ServerException.fromJson(res.statusCode, json.decode(res.body));
  }
}
