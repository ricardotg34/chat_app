import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
        theme: ThemeData.dark().copyWith(
            primaryColor: Colors.red[900],
            accentColor: Colors.redAccent,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red[900], onPrimary: Colors.white)),
            iconTheme: IconThemeData(color: Colors.red),
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900])),
      ),
    );
  }
}
