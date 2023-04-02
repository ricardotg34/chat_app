import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    this.chatService = context.read<ChatService>();
    this.socketService = context.read<SocketService>();
    this.authService = context.read<AuthService>();
    super.initState();

    this.socketService.socket.on('personal-message', _listenToMessage);
    _loadMessages(this.chatService.userToSend.id);
  }

  void _listenToMessage(dynamic data) {
    ChatMessage message = new ChatMessage(
        text: data['message'],
        uid: data['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    // TODO Off of socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            CircleAvatar(
              child: Text(chatService.userToSend.name.substring(0, 2),
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              backgroundColor: Theme.of(context).primaryColor,
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(chatService.userToSend.name, style: TextStyle(fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, i) => _messages[i],
                reverse: true,
              )),
              Divider(height: 1),
              Container(
                height: 50,
                child: _InputChat(onSubmit: _handleSubmit),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length > 0) {
      final newMessage = new ChatMessage(
        uid: authService.user.id,
        text: text,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)),
      );
      newMessage.animationController.forward();
      setState(() {
        _messages.insert(0, newMessage);
      });
      this.socketService.emit('personal-message', {
        'from': authService.user.id,
        'to': this.chatService.userToSend.id,
        'message': text
      });
    }
  }

  void _loadMessages(String id) async {
    List<Message> chat = await this.chatService.getConversationMessages(id);

    final history = chat.map((e) => new ChatMessage(
        text: e.message,
        uid: e.from,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }
}

class _InputChat extends StatefulWidget {
  final void Function(String) onSubmit;

  const _InputChat({Key key, @required this.onSubmit}) : super(key: key);
  @override
  __InputChatState createState() => __InputChatState();
}

class __InputChatState extends State<_InputChat> {
  final _textControler = new TextEditingController();
  final _focusNode = new FocusNode();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textControler,
              onSubmitted: _handleSubmit,
              onChanged: (text) {
                setState(() {
                  isTyping = text.trim().length > 0;
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar', style: TextStyle(color: Colors.red)),
                    onPressed: isTyping
                        ? () => _handleSubmit(_textControler.text.trim())
                        : null)
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: isTyping
                          ? () => _handleSubmit(_textControler.text.trim())
                          : null,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  _handleSubmit(String text) {
    widget.onSubmit(text);
    _focusNode.requestFocus();
    _textControler.clear();
    setState(() {
      isTyping = false;
    });
  }
}
