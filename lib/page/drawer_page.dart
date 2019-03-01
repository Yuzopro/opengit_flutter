import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  final String name, email, headUrl;

  DrawerPage({this.name, this.email, this.headUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(name),
            accountEmail: new Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: new NetworkImage(this.headUrl),
            ),
          ),
//          new ListTile(
//            title: new Text("用户余额"),
//            leading: new Icon(Icons.attach_money, color: Colors.grey),
//            onTap: () {
//              Navigator.of(context).pop();
//              if (LoginManager.instance.isLogin()) {
//                routePagerNavigator(context, new PayPage());
//              } else {
//                routePagerNavigator(context, new LoginPage());
//              }
//            },
//          ),
        ],
      ),
    );
  }
}
