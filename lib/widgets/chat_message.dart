import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {Key key,
      @required this.text,
      @required this.uid,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOwnMessage = this.uid == '123';
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: Align(
            alignment:
                isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  bottom: 5,
                  left: isOwnMessage ? 50 : 5,
                  right: isOwnMessage ? 5 : 50),
              child: Text(this.text, style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                  color: isOwnMessage
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
    );
  }
}
