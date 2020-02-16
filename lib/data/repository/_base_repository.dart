import 'dart:async';
import 'dart:io';

import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/res/R.dart';

class BaseRepository {
  ResultError<T> resultError<T>(dynamic ex) {
    String message = R.string.failedOperation;
    if (ex is ServerException) {
      message = ex.message;
    } else if (ex is SocketException) {
      message = R.string.checkNetworkConnection;
    }
    return Result.error(error: message);
  }
}
