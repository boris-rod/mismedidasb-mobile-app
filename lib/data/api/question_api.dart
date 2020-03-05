import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/question/i_question_api.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';
import 'package:mismedidasb/domain/question/question_model.dart';

class QuestionApi extends BaseApi implements IQuestionApi {
  final IQuestionConverter _iQuestionConverter;
  final NetworkHandler _networkHandler;

  QuestionApi(this._iQuestionConverter, this._networkHandler);

  @override
  Future<List<QuestionModel>> getQuestionList(int pollId) async {
    final res = await _networkHandler.get(
        path: Endpoint.question, params: "?${RemoteConstants.poll_id}=$pollId");
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = jsonDecode(res.body)[RemoteConstants.result];
      return l.map((model) => _iQuestionConverter.fromJson(model)).toList();
    }
    throw serverException(res);
  }
}
