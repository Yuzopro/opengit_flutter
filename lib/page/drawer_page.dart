import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/shared_prf_util.dart';

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
            currentAccountPicture: new GestureDetector(
              //用户头像
              onTap: () {
                UserBean userBean = LoginManager.instance.getUserBean();
                NavigatorUtil.goUserProfile(context, userBean);
              },
              child: new ClipOval(
                child: ImageUtil.getImageWidget(this.headUrl ?? "", 64.0),
              ),
            ),
            onDetailsPressed: () {
              UserBean userBean = LoginManager.instance.getUserBean();
              NavigatorUtil.goUserProfile(context, userBean);
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.trend),
            leading: new Icon(Icons.trending_up, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goTrend(context, "all");
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.bookmark),
            leading: new Icon(Icons.bookmark, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goBookMark(context);
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.setting),
            leading: new Icon(Icons.settings, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goSetting(context);
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.about),
            leading: new Icon(Icons.info, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goAbout(context);
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.share),
            leading: new Icon(Icons.share, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goShare(context);
            },
          ),
          new ListTile(
            title: new Text(AppLocalizations.of(context).currentlocal.logout),
            leading: new Icon(Icons.power_settings_new, color: Colors.grey),
            onTap: () {
              _handleLogoutApp(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _handleLogoutApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .currentlocal
                  .dialog_logout_title),
              content: Text(AppLocalizations.of(context)
                  .currentlocal
                  .dialog_logout_content),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).currentlocal.cancel,
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).currentlocal.ok,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    LoginManager.instance.clearAll();
                    NavigatorUtil.goLogin(context);
                  },
                ),
              ],
            ));
  }
}
