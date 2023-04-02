import 'dart:io';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/responses/conversation_messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userToSend;
  final _storage = new FlutterSecureStorage();

  Future<List<Message>> getConversationMessages(String userID) async {
    try {
      final token = await this._storage.read(key: 'token');
      final res = await http.get(
          Uri.parse('${Environment.apiChatUrl}/conversation/$userID'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (res.statusCode == 200) {
        final mappedRes = ConversationMessagesResponse.fromJson(res.body);
        return mappedRes.data;
      } else if (res.statusCode == 401)
        throw HttpException('Token inválido.');
      else
        throw HttpException('Hubo un problema al cargar los mensajes');
    } on HttpException catch (e) {
      throw e;
    } on SocketException {
      throw new Exception('Se ha perdido conexión con el servidor');
    }
  }
}
