import 'dart:convert';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/util/locale_util.dart';
import 'package:open_git/util/shared_prf_util.dart';
import 'package:open_git/util/theme_util.dart';
import 'package:redux/redux.dart';

class UserMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "UserMiddleware";

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is InitAction) {
      await _init(store, action, next);
    } else {
      next(action);
    }
  }

  Future<Null> _init(
      Store<AppState> store, InitAction action, NextDispatcher next) async {
    LoginManager.instance.initData();
    //主题
    int theme = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_THEME_COLOR);
    if (theme != null) {
      Color color = new Color(theme);
      next(RefreshThemeDataAction(AppTheme.changeTheme(color)));
    }
    //语言
    int locale = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_LANGUAGE_COLOR);
    if (locale != null) {
      next(RefreshLocalAction(LocaleUtil.changeLocale(store.state, locale)));
    }
    //用户信息
    String token = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_TOKEN);
    UserBean userBean = null;
    var user = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_USER_INFO);
    if (user != null && user.length > 0) {
      var data = jsonDecode(user);
      userBean = UserBean.fromJson(data);
    }
    next(InitCompleteAction(token, userBean));
  }
}
