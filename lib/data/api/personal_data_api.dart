import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_api.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_converter.dart';
import 'package:mismedidasb/domain/personal_data/personal_data_model.dart';

class PersonalDataApi extends BaseApi implements IPersonalDataApi {
  final IPersonalDataConverter _iPersonalDataConverter;
  final NetworkHandler _networkHandler;

  PersonalDataApi(this._iPersonalDataConverter, this._networkHandler);

  @override
  Future<List<PersonalDataModel>> getPersonalData() async {
    final res =
        await _networkHandler.get(path: Endpoint.personal_data_current_data);
    if (res.statusCode == RemoteConstants.code_success) {
      Iterable l = json.decode(res.body)[RemoteConstants.result];
      return l.map((model) => _iPersonalDataConverter.fromJson(model)).toList();
    } else
      throw serverException(res);
  }
}
