import 'dart:convert';

import 'package:mismedidasb/fcm/fcm_message_model.dart';


class FCMJsonParser {
  static FCMMessageModel parseJson(Map<String, dynamic> fcmJson) {
    try {
      final dataJson = fcmJson['data'] ?? fcmJson;
      if (dataJson == null) return null;
      final actionJson = json.decode(dataJson['action']);
      if (actionJson == null) return null;

      String userId = actionJson['userId'];
      if (userId == null) return null;

      String type = actionJson['type'];

      final todo = json.decode(dataJson['todo']);
      final todoId = todo == null ? null : todo['id'];

      var title = '';
      final notificationJson = fcmJson['notification'];
      if (notificationJson != null) title = notificationJson['title'];


      return FCMMessageModel(
        userId: userId,
        type: type,
        todoId: todoId,
        title: title,
      );
    }catch(ex){
      print(ex);
      return null;
    }
  }
}
