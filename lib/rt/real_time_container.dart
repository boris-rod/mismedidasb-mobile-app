import 'dart:convert';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/rt/i_real_time_container.dart';
import 'package:mismedidasb/utils/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:mismedidasb/utils/extensions.dart';

//BehaviorSubject<RewardModel> onRewardSoloPollAnsweredSubject =
//    BehaviorSubject<RewardModel>();
//BehaviorSubject<RewardModel> onRewardPollAnsweredSubject =
//    BehaviorSubject<RewardModel>();

class RealTimeContainer implements IRealTimeContainer {
  final SharedPreferencesManager _prefs;

  RealTimeContainer(this._prefs);

  @override
  void setup() async {
//    String accessToken = await _prefs.getStringValue(SharedKey.accessToken);
//    int userId = await _prefs.getIntValue(SharedKey.userId);
//
//    accessToken = accessToken.startsWith("Bearer ")
//        ? accessToken.split("Bearer ").last
//        : accessToken;
//    if (accessToken?.isNotEmpty == true) {
//      final httpOptions = new HttpConnectionOptions(
//          accessTokenFactory: () async => accessToken);
//
//      final hubConnection = HubConnectionBuilder()
//          .withUrl("${Endpoint.apiBaseUrl}/userHub", options: httpOptions)
//          .build();
//
//      hubConnection.onclose((error) async {});
//
//      hubConnection.on("OnRewardCreated", (List<dynamic> list) {
//        Map json = list[0];
//        print(json);
//      });
//
//      await hubConnection.start().catchError((err) {
//        print(err.toString());
//      });
//    }
  }

  @override
  void dispose() {
  }
}
