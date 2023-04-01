import 'dart:convert';

class LoginResponse {
  LoginResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  int statusCode;
  String message;
  Data data;

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({this.accessToken, this.username});

  String accessToken;
  String username;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "username": username,
      };
}
