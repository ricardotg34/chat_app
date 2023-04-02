import 'dart:convert';
import 'dart:io';
import 'package:chat_app/helpers/parseJWT.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/responses/login_response.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  bool _isFetching = false;
  final _storage = new FlutterSecureStorage();

  bool get isFetching => this._isFetching;
  User user;

  set isFetching(bool value) {
    this._isFetching = value;
    notifyListeners();
  }

  setUser(String token) {
    var parsedPayload = parseJwt(token);
    this.user = new User(
        id: parsedPayload['id'],
        email: parsedPayload['email'],
        name: parsedPayload['name']);
    print(parsedPayload);
    print(this.user.name);
  }

  String getJsonFromJWT(String splittedToken) {
    String normalizedSource = base64Url.normalize(splittedToken);
    return utf8.decode(base64Url.decode(normalizedSource));
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<void> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    this.isFetching = true;
    try {
      final res = await http.get(
          Uri.parse('${Environment.apiUserUrl}/renew-token'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (res.statusCode == 200) {
        final mappedRes = LoginResponse.fromRawJson(res.body);
        await _storage.write(key: 'token', value: mappedRes.data.accessToken);
        setUser(mappedRes.data.accessToken);
      } else if (res.statusCode == 401)
        throw HttpException('Token inválido.');
      else
        throw HttpException('Hubo un problema al crear el usuario');
    } on HttpException catch (e) {
      throw e;
    } on SocketException {
      throw new Exception('Se ha perdido conexión con el servidor');
    } finally {
      this.isFetching = false;
    }
  }

  Future<void> login(String email, String password) async {
    this.isFetching = true;
    final data = {'email': email, 'password': password};
    try {
      final res = await http.post(
          Uri.parse('${Environment.apiUserUrl}/sign-in'),
          body: jsonEncode(data),
          headers: {'Content-type': 'application/json'});
      if (res.statusCode == 200) {
        final mappedRes = LoginResponse.fromRawJson(res.body);
        await _storage.write(key: 'token', value: mappedRes.data.accessToken);
        setUser(mappedRes.data.accessToken);
      } else if (res.statusCode == 400)
        throw HttpException('El usuario o la contraseña son incorrectos.');
      else
        throw HttpException('Hubo un problema al iniciar sesión');
    } on HttpException catch (e) {
      throw e;
    } on SocketException {
      throw new Exception('Se ha perdido conexión con el servidor');
    } finally {
      this.isFetching = false;
    }
  }

  Future<void> register(String email, String password, String name) async {
    this.isFetching = true;
    final data = {"email": email, "password": password, "name": name};
    try {
      final res = await http.post(Uri.parse('${Environment.apiUserUrl}'),
          body: jsonEncode(data),
          headers: {'Content-type': 'application/json'});
      this._isFetching = false;
      if (res.statusCode == 400)
        throw HttpException('El usuario ya existe.');
      else if (res.statusCode != 201)
        throw HttpException('Hubo un problema al crear el usuario');
    } on HttpException catch (e) {
      throw e;
    } on SocketException {
      throw new Exception('Se ha perdido conexión con el servidor');
    } finally {
      this.isFetching = false;
    }
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
