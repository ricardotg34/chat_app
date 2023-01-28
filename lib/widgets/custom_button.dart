import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;

  const CustomButton({Key key, this.onPressed, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(elevation: 2, shape: StadiumBorder()),
      child: Container(
        width: double.infinity,
        child: Center(
            child: Text(
          this.label,
          style: TextStyle(fontSize: 18),
        )),
      ),
    );
  }
}
