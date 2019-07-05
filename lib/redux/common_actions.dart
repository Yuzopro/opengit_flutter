import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';

class InitAction {}

class InitCompleteAction {
  InitCompleteAction(
    this.token,
    this.userBean,
  );

  final String token;
  final UserBean userBean;
}

class ResetPageAction {
  final ListPageType type;

  ResetPageAction(this.type);
}

class IncreasePageAction {
  final ListPageType type;

  IncreasePageAction(this.type);
}

class FetchAction {
  final ListPageType type;

  FetchAction(this.type);
}

class RefreshAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;

  RefreshAction(this.refreshStatus, this.type);
}

//刷新主题
class RefreshThemeDataAction {
  final ThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}

//刷新语言
class RefreshLocalAction {
  final Locale locale;

  RefreshLocalAction(this.locale);
}
