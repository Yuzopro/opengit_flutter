import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/red_point_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';
import 'package:redux/redux.dart';

class DrawerPage extends StatefulWidget {
  static final String TAG = "DrawerPage";

  DrawerPage();

  @override
  State<StatefulWidget> createState() {
    return _DrawerPageState();
  }
}

class _DrawerPageState extends State<DrawerPage> {
  UserBean _userBean;

  @override
  void initState() {
    super.initState();
    RedPointManager.instance.addState(this);
    _userBean = LoginManager.instance.getUserBean();
  }

  @override
  void dispose() {
    super.dispose();
    RedPointManager.instance.removeState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_userBean.name ?? _userBean.login ?? '',
                style: YZStyle.normalTextWhite),
            accountEmail: Text(_userBean.email, style: YZStyle.smallTextWhite),
            currentAccountPicture: InkWell(
              //用户头像
              onTap: () {
                NavigatorUtil.goUserProfile(context, _userBean.login,
                    _userBean.avatar_url ?? "", "hero_drawer_image_");
              },
              child: Hero(
                tag: "hero_drawer_image_${_userBean?.login??""}",
                child: ImageUtil.getCircleNetworkImage(
                  _userBean.avatar_url ?? "",
                  YZSize.LARGE_IMAGE_SIZE,
                  ImagePath.image_default_head,
                ),
                transitionOnUserGestures: true,
              ),
            ),
            onDetailsPressed: () {
              NavigatorUtil.goUserProfile(context, _userBean.login,
                  _userBean.avatar_url ?? "", "hero_drawer_image_");
            },
            otherAccountsPictures: <Widget>[
              InkWell(
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: YZSize.NORMAL_IMAGE_SIZE,
                ),
                onTap: () {
                  _goEditProfile();
                },
              ),
            ],
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.trend,
                style: YZStyle.middleText),
            leading: Icon(Icons.trending_up, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goTrend(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.track,
                style: YZStyle.middleText),
            leading: Icon(Icons.directions_run, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goTrack(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.setting,
                style: YZStyle.middleText),
            leading: Icon(Icons.settings, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goSetting(context);
            },
          ),
          ListTile(
            title: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Text(AppLocalizations.of(context).currentlocal.about,
                    style: YZStyle.middleText),
                Offstage(
                  offstage: !RedPointManager.instance.isUpgrade,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CommonUtil.getRedPoint(),
                  ),
                ),
              ],
            ),
            leading: Icon(Icons.info, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goAbout(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.share,
                style: YZStyle.middleText),
            leading: Icon(Icons.share, color: Colors.grey),
            onTap: () {
              NavigatorUtil.goShare(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).currentlocal.logout,
                style: YZStyle.middleText),
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
        title:
            Text(AppLocalizations.of(context).currentlocal.dialog_logout_title),
        content: Text(
            AppLocalizations.of(context).currentlocal.dialog_logout_content),
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
      ),
    );
  }

  void _goEditProfile() async {
    await NavigatorUtil.goEditProfile(context);
    setState(() {
      _userBean = LoginManager.instance.getUserBean();
    });
  }
}
