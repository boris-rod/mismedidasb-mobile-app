import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/utils/logger.dart';

export 'package:http/http.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class NetworkHandler {
  final Logger _logger;
  final SharedPreferencesManager _sharedP;

  NetworkHandler(this._sharedP, this._logger);

  ///Returns the common headers with authentication values
  Future<Map<String, String>> _commonHeaders() async {
    return {
      'Authorization': '${await _sharedP.getAccessToken()}',
      'Content-Type': 'application/json'
    };
  }

  ///Get operations.
  ///-The base URL by default is the one provided by the Injector.
  ///-The [path] is mandatory
  ///-The request already handles authentication
  ///-The request already handles refresh token implementation
  Future<http.Response> get({
    @required String path,
    String params = '',
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();

    try {
      _logger.log("-> GET: $_url");
      _logger.log("-> HEADERS: $_headers");
      final res = await http.get(_url, headers: _headers);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          final resAfterRefresh = await http.get(_url, headers: _newHeaders);
          return resAfterRefresh;
        } else
          return refreshResult;
      }
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  ///Post operations.
  ///-The base URL by default is the one provided by the Injector.
  ///-The [path] is mandatory
  ///-The request's content type is application/json
  ///-The request already handles authentication
  ///-The request already handles refresh token implementation
  Future<http.Response> post({
    @required String path,
    String params = '',
    String body = "",
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();

    try {
      _logger.log("-> POST: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.post(_url, headers: _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          final resAfterRefresh =
          await http.post(_url, headers: _newHeaders, body: body);
          return resAfterRefresh;
        } else
          return refreshResult;
      }
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  ///Put operations.
  ///-The base URL by default is the one provided by the Injector.
  ///-The [path] is mandatory
  ///-The request's content type is application/json
  ///-The request already handles authentication
  ///-The request already handles refresh token implementation
  Future<http.Response> put({
    @required String path,
    String params = '',
    String body,
    Map<String, String> headers = const {},
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();
    try {
      _logger.log("-> PUT: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.put(_url, headers: _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          final resAfterRefresh =
          await http.put(_url, headers: _newHeaders, body: body);
          return resAfterRefresh;
        } else
          return refreshResult;
      }
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  ///Delete operations.
  ///-The base URL by default is the one provided by the Injector.
  ///-The [path] is mandatory
  ///-The request already handles authentication
  ///-The request already handles refresh token implementation
  Future<http.Response> delete({
    @required String path,
    String params = '',
    Map<String, String> headers = const {},
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();
    try {
      _logger.log("-> DELETE: $_url");
      _logger.log("-> HEADERS: $_headers");
      final res = await http.delete(_url, headers: _headers);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          final resAfterRefresh = await http.delete(_url, headers: _newHeaders);
          return resAfterRefresh;
        } else
          return refreshResult;
      }
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }


  Future<http.Response> _refreshToken() async {
    final url = "${Endpoint.apiBaseUrl}${Endpoint.refresh_token}";
    final refreshToken = await _sharedP.getRefreshToken();
    final accessToken = await _sharedP.getAccessToken();
    final body = json.encode({
      "token": accessToken.startsWith("Bearer ")
          ? accessToken.split("Bearer ")[1]
          : accessToken,
      "refreshToken": refreshToken
    });
    try {
      _logger.log("-> POST: $url");
      _logger.log("-> BODY: $body");
      final _headers = {'Content-Type': 'application/json'};

      _logger.log("-> HEADERS: $_headers");
      var res = await http.post(url, headers: _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");

      _sharedP.setAccessToken(res.headers[RemoteConstants.authorization] ?? "");
      _sharedP.setRefreshToken(res.headers[RemoteConstants.refreshToken] ?? "");

      return res;
    } catch (ex) {
      throw ex;
    }
  }

}
