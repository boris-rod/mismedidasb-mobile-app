import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/src/media_type.dart' as mt;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/utils/file_manager.dart';
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
  Future<http.Response> post(
      {@required String path,
      String params = '',
      String body = "",
      bool doRefreshToken = true}) async {
    final _url = Endpoint.apiBaseUrl + path + params;
    final _headers = await _commonHeaders();

    try {
      _logger.log("-> POST: $_url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.post(_url, headers: _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (doRefreshToken &&
          res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          _logger.log("-> POST: $_url");
          _logger.log("-> HEADERS: $_newHeaders");
          _logger.log("-> BODY: $body");
          final resAfterRefresh =
              await http.post(_url, headers: _newHeaders, body: body);
          _logger.log("<- RESPONSE CODE: ${res.statusCode}");
          _logger.log("<- RESPONSE BODY: ${res.body}");
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

  Future<http.Response> validateToken() async {
    final url = "${Endpoint.apiBaseUrl}${Endpoint.validate_token}";
    try {
      String accessToken = await _sharedP.getStringValue(SharedKey.accessToken);
      accessToken = accessToken.startsWith("Bearer ")
          ? accessToken.split("Bearer ")[1]
          : accessToken;
      final _headers = await _commonHeaders();
      final body = jsonEncode({"token": accessToken});
      _logger.log("-> POST: $url");
      _logger.log("-> HEADERS: $_headers");
      _logger.log("-> BODY: $body");
      final res = await http.post(url, headers: _headers, body: body);
      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.body}");
      if (res.statusCode == RemoteConstants.code_un_authorized) {
        final refreshResult = await _refreshToken();
        if (refreshResult.statusCode == RemoteConstants.code_success) {
          final _newHeaders = await _commonHeaders();
          accessToken = await _sharedP.getStringValue(SharedKey.accessToken);
          accessToken = accessToken.startsWith("Bearer ")
              ? accessToken.split("Bearer ")[1]
              : accessToken;
          final newBody = jsonEncode({"token": accessToken});

          _logger.log("-> POST: $url");
          _logger.log("-> HEADERS: $_newHeaders");
          _logger.log("-> BODY: $newBody");
          final resAfterRefresh =
              await http.post(url, headers: _newHeaders, body: newBody);
          _logger.log("<- RESPONSE CODE: ${res.statusCode}");
          _logger.log("<- RESPONSE BODY: ${res.body}");
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
    final refreshToken = await _sharedP.getStringValue(SharedKey.refreshToken);
    final accessToken = await _sharedP.getStringValue(SharedKey.accessToken);
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

      final String accessToken = res.headers["authorization"] ?? "";
      final String refreshToken = res.headers["refreshtoken"] ?? "";
      await _sharedP.setStringValue(SharedKey.accessToken, accessToken);
      await _sharedP.setStringValue(SharedKey.refreshToken, refreshToken);

      return res;
    } catch (ex) {
      throw ex;
    }
  }

  Future<Response> postFile({
    @required String path,
    @required File file,
  }) async {
    final _url = Endpoint.apiBaseUrl + path;
    final _headers = {'Authorization': '${await _sharedP.getAccessToken()}'};
    _headers.addAll({"Content-Type": "multipart/form-data"});
    _logger.log("-> POST: $_url");
    _logger.log("-> HEADERS: $_headers");

    try {
      final fileName = file.path.split("/").last;

      File postFile;
      if (file.lengthSync() > 2090000) {
        final root = await FileManager.getRootFilesDir();
        postFile =
            await FileManager.compressAndGetFile(file, "$root/$fileName");
      } else {
        postFile = File(file.path);
      }

      final String mime = lookupMimeType(postFile.path);
      final mimeArray = mime.split("/");

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(postFile.path,
            filename: fileName, contentType: mt.MediaType(mimeArray.first, mimeArray.last))
      });
      BaseOptions options = new BaseOptions(
          connectTimeout: 10000, receiveTimeout: 4000, headers: _headers);
      Dio dio = new Dio();
      dio.options = options;
      final res = await dio.post(
        _url,
        data: formData,
      );

      _logger.log("<- RESPONSE CODE: ${res.statusCode}");
      _logger.log("<- RESPONSE BODY: ${res.toString()}");
      return res;
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      throw ex;
    }
  }

  Future<int> uploadMultipartForm(
      {@required String path,
      String name,
      String method = 'post',
      List<Map<String, dynamic>> dishes,
      File file}) async {
    try {
      final _url = Endpoint.apiBaseUrl + path;
      final _headers = {'Authorization': '${await _sharedP.getAccessToken()}'};
      _headers.addAll({"Content-Type": "multipart/form-data"});

      _logger.log("-> POST: $_url");
      _logger.log("-> HEADERS: $_headers");

      final fileName = file != null ? file.path.split("/").last : "";

      File postFile;
      MultipartFile multipartFile;
      if (file != null) {
        if (file.lengthSync() > 2090000) {
          final root = await FileManager.getRootFilesDir();
          postFile =
              await FileManager.compressAndGetFile(file, "$root/$fileName");
        } else {
          postFile = File(file.path);
        }
        final String mime = lookupMimeType(postFile.path);
        final mimeArray = mime.split("/");
        multipartFile = await MultipartFile.fromFile(postFile.path,
            filename: fileName,
            contentType: mt.MediaType(mimeArray.first, mimeArray.last));
      }

      final FormData formData = FormData.fromMap({
        "name": name,
        "dishes": dishes,
        "image": multipartFile,
      });

      _logger.log(formData.fields);
      formData.files.map((e) =>  _logger.log(e.toString()));


      BaseOptions options = new BaseOptions(
          connectTimeout: 10000, receiveTimeout: 4000, headers: _headers);
      Dio dio = new Dio();
      dio.options = options;
      if (method == 'put') {
        final res = await dio.put(
          _url,
          data: formData,
        );
        _logger.log("-> RESPONSE: ${res.data}");
        _logger.log("-> RESPONSE CODE: ${res.statusCode}");
        return res.statusCode;
      } else {
        final res = await dio.post(
          _url,
          data: formData,
        );
        return res.statusCode;
      }
    } catch (ex) {
      _logger.log("<- EXEPTION: $ex");
      return 0;
    }
  }
}
