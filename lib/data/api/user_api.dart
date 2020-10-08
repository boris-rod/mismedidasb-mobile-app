import 'dart:convert';
import 'dart:io';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/_base_api.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/exceptions.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserApi extends BaseApi implements IUserApi {
  final IUserConverter _iUserConverter;
  final NetworkHandler _networkHandler;
  final SharedPreferencesManager _sharedPreferencesManager;

  UserApi(this._iUserConverter, this._networkHandler,
      this._sharedPreferencesManager);

  @override
  Future<UserModel> getProfile() async {
    final res = await _networkHandler.get(
      path: Endpoint.profile,
    );
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJson(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<UserModel> updateProfile(UserModel userModel) async {
    final body = {
      "fullName": userModel.fullName,
      "username": userModel.username,
      "phone": ""
    };
    final res = await _networkHandler.post(
        path: Endpoint.profile, body: jsonEncode(body));
    if (res.statusCode == RemoteConstants.code_success)
      return userModel;
    else
      throw serverException(res);
  }

  @override
  Future<bool> uploadAvatar(File photo) async {
    final res = await _networkHandler.postFile(
      path: Endpoint.upload_avatar,
      file: photo,
    );
    return res.statusCode == RemoteConstants.code_success;
  }

  @override
  Future<bool> invite(List<String> emails) async {
    List<Map<String, String>> mapList = [];
    emails.forEach((element) {
      mapList.add({"email": element});
    });

    final res = await _networkHandler.post(
        path: Endpoint.invite, body: jsonEncode(mapList));
    return res.statusCode == RemoteConstants.code_success_created;
    throw UnimplementedError();
  }

  @override
  Future<ScoreModel> getScores() async {
    final userId =
        await _sharedPreferencesManager.getIntValue(SharedKey.userId);
    final res = await _networkHandler.get(
        path: Endpoint.scores, params: "?userId=$userId");
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJsonScore(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<UsernameSuggestionModel> usernameValidation(
      int userId, String email, String username, String fullName) async {
    final res = await _networkHandler.get(
        path: Endpoint.username_validation,
        params:
            "?userId=$userId&username=$username&fullName=$fullName&email=$email");
    if (res.statusCode == RemoteConstants.code_success) {
      return _iUserConverter
          .fromJsonUsernameSuggestionModel(jsonDecode(res.body)["result"]);
    }
    throw serverException(res);
  }

  @override
  Future<SoloQuestionStatsModel> getSoloQuestionStats(int daysAgo) async {
    final userId =
        await _sharedPreferencesManager.getIntValue(SharedKey.userId);
    final res = await _networkHandler.get(
        path: Endpoint.solo_question_stats,
        params: "/$userId/extended?lastNDays=$daysAgo");
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter.fromJsonSoloQuestionStats(
          jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<AppVersionModel> getAppVersion() async {
    final res = await _networkHandler.get(
      path: Endpoint.app_version,
    );
    if (res.statusCode == RemoteConstants.code_success)
      return _iUserConverter
          .fromJsonAppVersion(jsonDecode(res.body)[RemoteConstants.result]);
    else
      throw serverException(res);
  }

  @override
  Future<bool> stripePaymentAction() async {
    final res = await _networkHandler.post(
      path: Endpoint.stripe_payment_action,
    );
    if (res.statusCode == RemoteConstants.code_success)
      return true;
    else
      throw serverException(res);
  }
}
