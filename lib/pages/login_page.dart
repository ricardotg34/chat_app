import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  label: '¿No tienes cuenta?',
                  linkText: '¡Crea una ahora!',
                  routeToGo: 'register',
                ),
                Text('Términos t condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              controller: emailCtrl,
              icon: Icons.mail_outline,
              placeholder: 'Correo',
              keyboardType: TextInputType.emailAddress),
          CustomInput(
            controller: passwordCtrl,
            icon: Icons.mail_outline,
            placeholder: 'Contraseña',
            isPassword: true,
          ),
          if (errorMessage.isNotEmpty)
            Text(errorMessage,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.red)),
          CustomButton(
              label: 'Ingrese',
              onPressed: authService.isFetching ? null : handlePressed)
        ],
      ),
    );
  }

  void handlePressed() async {
    FocusScope.of(context).unfocus();
    final authService = context.read<AuthService>();
    final socketService = context.read<SocketService>();
    try {
      await authService.login(emailCtrl.text.trim(), passwordCtrl.text.trim());
      socketService.connect();
      Navigator.pushReplacementNamed(context, 'users');
    } catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
}
