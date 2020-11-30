import 'dart:convert';

class   FCMMessageModel {
  final String externalUrl;

  FCMMessageModel({
    this.externalUrl
  });

  factory FCMMessageModel.fromString(Map<String, dynamic> bodyJson) {
    return FCMMessageModel(
      externalUrl: bodyJson['externalUrl'],
    );
  }
}
