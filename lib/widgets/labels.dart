import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String routeToGo;
  final String label;
  final String linkText;

  const Labels({Key key, this.routeToGo, this.label, this.linkText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.routeToGo);
            },
            child: Text(this.linkText,
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
