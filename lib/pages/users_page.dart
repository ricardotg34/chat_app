import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<User> users = [];

  @override
  void initState() {
    this._handleLoadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = context.watch<SocketService>();
    final authService = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(authService.username),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app,
              color: Theme.of(context).primaryIconTheme.color),
          onPressed: _handleLogoutPressed,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.green[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: UsersListView(users: users),
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        onRefresh: _handleLoadUsers,
      ),
    );
  }

  void _handleLoadUsers() async {
    final userService = new UserService();
    try {
      final users = await userService.getUsers();
      setState(() {
        this.users = users;
      });
      _refreshController.refreshCompleted();
    } catch (e) {}
  }

  void _handleLogoutPressed() {
    final authService = context.read<AuthService>();
    final socketService = context.read<SocketService>();
    Navigator.pushReplacementNamed(context, 'login');
    socketService.disconnect();
    authService.logout();
  }
}

class UsersListView extends StatelessWidget {
  const UsersListView({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _UserListTile(user: users[i]),
        separatorBuilder: (_, __) => Divider(),
        itemCount: users.length);
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(child: Text(user.name.substring(0, 2))),
      onTap: _handleTap(context),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.isOnline ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  void Function() _handleTap(BuildContext context) => () {
        final chatService = context.read<ChatService>();
        chatService.userToSend = user;
        Navigator.pushNamed(context, 'chat');
      };
}
