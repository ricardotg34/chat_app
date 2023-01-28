import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                  elevation: 5,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ));
  } else {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                  isDefaultAction: true,
                )
              ],
            ));
  }
}
