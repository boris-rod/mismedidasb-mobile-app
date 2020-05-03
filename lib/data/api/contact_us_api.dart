import 'dart:convert';

import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_api.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_converter.dart';
import 'package:mismedidasb/res/R.dart';

class ContactUsApi extends BaseApi implements IContactUsApi {
  final IContactUsConverter _contactUsConverter;
  final NetworkHandler _networkHandler;

  ContactUsApi(this._contactUsConverter, this._networkHandler);

  @override
  Future<String> sendInfo(ContactUsModel model) async {
    final body = jsonEncode(_contactUsConverter.toJson(model));
    final res = await _networkHandler.post(
        path: Endpoint.contact_us_send_info, body: body);
    if (res.statusCode == RemoteConstants.code_success_created)
      return R.string.contactUsResult;
    else
      throw serverException(res);
  }
}
