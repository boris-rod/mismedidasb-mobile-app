import 'dart:convert';

import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';

class BaseApi {
  ServerException serverException(Response res) {
    return ServerException.fromJson(json.decode(res.body));
  }
}
