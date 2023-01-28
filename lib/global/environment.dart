import 'dart:io';

class Environment {
  static String apiUserUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/users'
      : 'http://localhost:3000/users';

  static String socketUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/chat'
      : 'http://localhost:3000/chat';
}
