import 'dart:io';

import 'package:chat_app/global/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  final _storage = new FlutterSecureStorage();

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void Function(String, [dynamic]) get emit => this._socket.emit;

  void connect() async {
    final token = await _storage.read(key: 'token');
    try {
      // Dart client
      this._socket = IO.io(Environment.socketUrl, {
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true, // Important for socket authentication
        'extraHeaders': {HttpHeaders.authorizationHeader: 'Bearer $token'}
      });
      this._socket.onConnect((_) {
        this._socket.emitWithAck('events', 'Hola', ack: (data) {
          print('Data: $data');
        });
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
      });
      this._socket.on('events', print);
      _socket.onDisconnect((_) {
        print('Desconectado');
        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
