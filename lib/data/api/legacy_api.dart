import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_api.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_converter.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';

class LegacyApi extends BaseApi implements ILegacyApi {
  final NetworkHandler _networkHandler;
  final ILegacyConverter _iLegacyConverter;

  LegacyApi(this._networkHandler, this._iLegacyConverter);

  @override
  Future<bool> acceptTermsCond() async {
    final res = await _networkHandler.post(path: Endpoint.accept_terms_cond);
    if (res.statusCode == RemoteConstants.code_success)
      return true;
    else
      throw serverException(res);
  }

  @override
  Future<LegacyModel> getLegacyContent(int contentType) async {
    final res = await _networkHandler.get(
        path: Endpoint.legacy_content_by_type,
        params: "?contentType=$contentType");
    if (res.statusCode == RemoteConstants.code_success)
      return _iLegacyConverter
          .fromJson(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }
}
