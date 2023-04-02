import 'dart:convert';

class Message {
  Message({
    this.id,
    this.from,
    this.to,
    this.message,
    this.createdAt,
  });

  String id;
  String from;
  String to;
  String message;
  DateTime createdAt;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
      };
}
