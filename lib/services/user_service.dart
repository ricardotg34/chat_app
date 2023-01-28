import 'dart:io';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/responses/list_users_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final _storage = new FlutterSecureStorage();

  Future<List<User>> getUsers() async {
    try {
      final token = await this._storage.read(key: 'token');
      final res = await http.get(Uri.parse('${Environment.apiUserUrl}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (res.statusCode == 200) {
        final mappedRes = ListUsersResponse.fromJson(res.body);
        return mappedRes.data;
      } else if (res.statusCode == 401)
        throw HttpException('Token inválido.');
      else
        throw HttpException('Hubo un problema al crear el usuario');
    } on HttpException catch (e) {
      throw e;
    } on SocketException {
      throw new Exception('Se ha perdido conexión con el servidor');
    }
  }
}
