import 'package:flutter/material.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:redux/redux.dart';

class DrawerPage extends StatelessWidget {
  final String name, email, headUrl;

  DrawerPage({this.name, this.email, this.headUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: GestureDetector(
              //用户头像
              onTap: () {
                UserBean userBean = LoginManager.instance.getUserBean();
                NavigatorUtil.goUserProfile(context, userBean.login, userBean.avatarUrl);
              },
              child: ImageUtil.getCircleNetworkImage(this.headUrl ?? "", 64.0, "image/ic_default_head.png"),
            ),
            onDetailsPressed: () {
              UserBean userBean = LoginManager.instance.getUserBean();
              NavigatorUtil.goUserProfile(context, userBean.login, userBean.avatarUrl);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.trend),
            leading: Icon(Icons.trending_up, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goTrend(context);
            },
          ),
//          ListTile(
//            title: Text(AppLocalizations.of(context).currentlocal.bookmark),
//            leading: Icon(Icons.bookmark, color: Colors.grey),
//            onTap: () {
//              NavigatorUtil.goBookMark(context);
//            },
//          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.setting),
            leading: Icon(Icons.settings, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goSetting(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.about),
            leading: Icon(Icons.info, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goAbout(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.share),
            leading: Icon(Icons.share, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goShare(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.logout),
            leading: Icon(Icons.power_settings_new, color: Colors.grey),
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
        builder: (context) => AlertDialog(
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
                    Store<AppState> store = StoreProvider.of(context);
                    store.dispatch(InitCompleteAction('', null, false));
                    LoginManager.instance.clearAll();
                    CacheProvider provider = CacheProvider();
                    provider.delete();
                    NavigatorUtil.goLogin(context);
                  },
                ),
              ],
            ));
  }
}
