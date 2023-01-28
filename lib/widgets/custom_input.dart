import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final bool isPassword;
  final IconData icon;
  final String placeholder;
  final TextInputType keyboardType;
  final TextEditingController controller;

  CustomInput(
      {this.isPassword = false,
      @required this.controller,
      @required this.icon,
      @required this.placeholder,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: TextField(
          controller: this.controller,
          autocorrect: false,
          keyboardType: this.keyboardType,
          obscureText: this.isPassword,
          decoration: InputDecoration(
              prefixIcon: Icon(this.icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: this.placeholder),
        ));
  }
}
