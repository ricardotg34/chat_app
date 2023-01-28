import 'dart:convert';

class User {
  User({
    this.id,
    this.isOnline,
    this.email,
    this.name,
  });

  String id;
  bool isOnline;
  String email;
  String name;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        isOnline: json["isOnline"],
        email: json["email"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "isOnline": isOnline,
        "email": email,
        "name": name,
      };
}
