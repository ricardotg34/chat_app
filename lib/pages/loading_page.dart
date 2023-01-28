import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(child: Text('Espere...'));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = context.read<AuthService>();
    final socketService = context.read<SocketService>();
    try {
      await authService.isLoggedIn();
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsersPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } catch (e) {
      print(e);
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
