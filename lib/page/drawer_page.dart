import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/actions.dart';
import 'package:open_git/redux/state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:redux/redux.dart';

import '../theme.dart';

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
            onDetailsPressed: () {
              UserBean userBean = LoginManager.instance.getUserBean();
              NavigatorUtil.goUserProfile(context, userBean);
            },
          ),
          new ListTile(
            title: new Text("趋势"),
            leading: new Icon(Icons.trending_up, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goReposTrending(context, "all");
            },
          ),
          new ListTile(
            title: new Text("书签"),
            leading: new Icon(Icons.bookmark, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goBookMark(context);
            },
          ),
          new ListTile(
            title: new Text("设置"),
            leading: new Icon(Icons.settings, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goSetting(context);
            },
          ),
          new ListTile(
            title: new Text("关于"),
            leading: new Icon(Icons.info, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goAppInfo(context);
            },
          ),
          new ListTile(
            title: new Text("分享"),
            leading: new Icon(Icons.share, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goShare(context);
            },
          ),
          new ListTile(
            title: new Text("注销"),
            leading: new Icon(Icons.power_settings_new, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goLogout(context);
            },
          ),
        ],
      ),
    );
  }
}
