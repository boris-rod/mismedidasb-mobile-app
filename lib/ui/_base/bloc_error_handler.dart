import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

class ErrorHandlerBloC {
  BehaviorSubject<String> _errorMessageController = new BehaviorSubject();

  Stream<String> get errorMessageStream => _errorMessageController.stream;

  void showErrorMessage(Result res) {
    String errorMessage = (res as ResultError)?.error ?? "";
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showErrorMessageAsString(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  onError(dynamic error) {
    if (error != null)
      _errorMessageController.sinkAddSafe(getResponseError(error));
    else
      clearError();
  }

  String getResponseError(dynamic error) {
//    if (error is SocketException) {
//      return R.string.error_check_your_connection;
//    }
//    if (error is ServerException) {
//      return error.message;
//    } else {
//      return error.toString();
//    }
    return error.toString();
  }

  clearError() {
    _errorMessageController.sinkAddSafe(null);
  }

  void disposeErrorHandlerBloC() {
    print('Error Handler Dispose');
    _errorMessageController.close();
  }
}
