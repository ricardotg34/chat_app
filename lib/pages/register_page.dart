import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
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
                Logo(
                  title: 'Registro',
                ),
                _Form(),
                Labels(
                  label: '¿Ya tienes cuenta?',
                  linkText: '¡Ingresa con ella!',
                  routeToGo: 'login',
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
  final nameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              controller: nameCtrl,
              icon: Icons.perm_identity,
              placeholder: 'Nombre',
              keyboardType: TextInputType.name),
          CustomInput(
              controller: emailCtrl,
              icon: Icons.mail_outline,
              placeholder: 'Correo',
              keyboardType: TextInputType.emailAddress),
          CustomInput(
            controller: passwordCtrl,
            icon: Icons.lock,
            placeholder: 'Contraseña',
            isPassword: true,
          ),
          CustomButton(label: 'Registrarse', onPressed: handlePressed)
        ],
      ),
    );
  }

  void handlePressed() async {
    FocusScope.of(context).unfocus();
    final authService = context.read<AuthService>();
    try {
      await authService.register(emailCtrl.text.trim(),
          passwordCtrl.text.trim(), nameCtrl.text.trim());
      showAlert(
          context, 'Usuario registrado', 'Se ha registrado correctamente.');
      Navigator.pushReplacementNamed(context, 'login');
    } catch (e) {
      showAlert(context, 'Error', e.message);
    }
  }
}
