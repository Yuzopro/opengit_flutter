import 'package:flutter/material.dart';
import 'package:open_git/redux/about/about_state.dart';
import 'package:open_git/redux/user/user_state.dart';
import 'package:open_git/util/theme_util.dart';

import 'login/login_state.dart';

class AppState {
  //主题
  final ThemeData themeData;

  //语言
  final Locale locale;

  //登录
  final LoginState loginState;

  //关于
  final AboutState aboutState;

  //用户信息
  final UserState userState;

  //系统语言
  Locale platformLocale;

  AppState({
    this.themeData,
    this.locale,
    this.loginState,
    this.userState,
    this.aboutState,
  });

  factory AppState.initial() => AppState(
        themeData: AppTheme.theme,
        locale: Locale('zh', 'CH'),
        loginState: LoginState.initial(),
        userState: UserState.initial(),
        aboutState: AboutState.initial(),
      );
}
