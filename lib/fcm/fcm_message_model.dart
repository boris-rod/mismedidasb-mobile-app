import 'dart:convert';

class FCMMessageModel {
  final String externalUrl;
  final String title;
  final String content;

  FCMMessageModel( {this.title, this.content, this.externalUrl});

  factory FCMMessageModel.fromString(Map<String, dynamic> bodyJson) {
    return FCMMessageModel(
      externalUrl: bodyJson['externalUrl'],
      title: bodyJson["notiTitle"],
      content: bodyJson["notiBody"]
    );
  }
}
