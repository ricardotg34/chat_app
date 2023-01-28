// To parse this JSON data, do
//
//     final listUsersResponse = listUsersResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user.dart';

class ListUsersResponse {
  ListUsersResponse({
    this.statusCode,
    this.data,
    this.message,
  });

  int statusCode;
  List<User> data;
  String message;

  factory ListUsersResponse.fromJson(String str) =>
      ListUsersResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListUsersResponse.fromMap(Map<String, dynamic> json) =>
      ListUsersResponse(
        statusCode: json["statusCode"],
        data: List<User>.from(json["data"].map((x) => User.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
      };
}
