// To parse this JSON data, do
//
//     final conversationMessagesResponse = conversationMessagesResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat_app/models/message.dart';

class ConversationMessagesResponse {
  ConversationMessagesResponse({
    this.statusCode,
    this.data,
    this.message,
  });

  int statusCode;
  List<Message> data;
  String message;

  factory ConversationMessagesResponse.fromJson(String str) =>
      ConversationMessagesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConversationMessagesResponse.fromMap(Map<String, dynamic> json) =>
      ConversationMessagesResponse(
        statusCode: json["statusCode"],
        data: List<Message>.from(json["data"].map((x) => Message.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
      };
}
