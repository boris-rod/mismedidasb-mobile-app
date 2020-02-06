import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
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
    return {'Authorization': '${await _sharedP.getAccessToken()}'};
  }

  ///Get operations.
  ///-The base URL by default is the one provided by the Injector.
  ///-The [path] is mandatory
  ///-The request already handles authentication
  ///-The request already handles refresh token implementation
  Future<http.Response> get({
    @required String path,
    String params = '',
    Map<String, String> headers = const {},
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();
    _headers.addAll(headers);

    try {
      _logger.log("-> GET: $_url");
      _logger.log("-> HEADERS: $_headers");
      final res =
          await http.get(_url, headers: _headers.isEmpty ? null : _headers);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");

//      if (res.statusCode == 401 && on401 != null) on401();
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
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();
    _headers.addAll(headers);

    Map<String, String> additionalHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    _headers.addAll(additionalHeaders);

    try {
      _logger.log("-> POST: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.post(_url,
          headers: _headers.isEmpty ? null : _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
//      if (res.statusCode == 401 && on401 != null && notify401) on401();
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
  Future<http.Response> postNoJson({
    @required String path,
    String params = '',
    bool requireAuth = true,
    Object body,
    bool notify401 = true,
    Map<String, String> headers = const {},
  }) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = requireAuth ? await _commonHeaders() : {};
    _headers.addAll(headers);

    try {
      _logger.log("-> POST: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.post(_url,
          headers: _headers.isEmpty ? null : _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
//      if (res.statusCode == 401 && on401 != null && notify401) on401();
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
    _headers.addAll(headers);

    Map<String, String> aditionalHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    _headers.addAll(aditionalHeaders);

    try {
      _logger.log("-> PUT: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.put(_url,
          headers: _headers.isEmpty ? null : _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
//      if (res.statusCode == 401 && on401 != null) on401();
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
    _headers.addAll(headers);

    try {
      _logger.log("-> DELETE: $_url");
      _logger.log("-> HEADERS: $_headers");
      final res =
          await http.delete(_url, headers: _headers.isEmpty ? null : _headers);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == 401) {
        final newToken = await _refreshToken();
        _logger.log("-> DELETE: $_url");
        _logger.log("-> HEADERS: $_headers");
        final res =
        await http.delete(_url, headers: _headers.isEmpty ? null : _headers);
        _logger.log("<- RESPONSE CODE: ${res.statusCode}");
        _logger.log("<- RESPONSE BODY: ${res.body}");
      }
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  Future<String> _refreshToken() async {}

  Future<http.Response> login({
    @required String url,
    Map<String, dynamic> body = const {},
  }) async {
    try {
      _logger.log("-> POST: $url");
      _logger.log("-> BODY: $body");
      final res = await http.post(url, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  Future<http.Response> forgotPassword({
    @required String path,
    String body = '',
  }) async {
    final _url = Endpoint.apiBaseUrl + path;

    try {
      _logger.log("-> POST: $_url");
      _logger.log("-> BODY: $body");
      final res = await http.post(_url, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }
}
