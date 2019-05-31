import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:redux/redux.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      return;
    }
    _isInit = true;

    new Future.delayed(const Duration(seconds: 2), () {
      Store<AppState> store = StoreProvider.of(context);
      LoginManager.instance.initData(store).then((userBean) {
        if (userBean != null) {
          NavigatorUtil.goMain(context);
        } else {
          NavigatorUtil.goLogin(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      child: new Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: new Image(
            width: 64.0,
            height: 64.0,
            image: new AssetImage('image/ic_welcome.png')),
      ),
    );
  }
}
