import 'dart:convert';

class FCMMessageModel {
  final String userId;
  final String type;
  final String todoId;
  final String title;

  FCMMessageModel({
    this.userId,
    this.type,
    this.todoId,
    this.title,
  });

  factory FCMMessageModel.fromString(String body) {
    final bodyJson = json.decode(body);
    return FCMMessageModel(
      userId: bodyJson['userId'],
      type: bodyJson['type'],
      todoId: bodyJson['todoId'],
      title: bodyJson['title'],
    );
  }

  String toJson() => jsonEncode({
    'userId':userId,
    'type':type,
    'todoId':todoId,
    'title':title,
  });
}
