import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';

class InitAction {}

class InitCompleteAction {
  InitCompleteAction(
    this.token,
    this.userBean,
    this.isGuide,
  );

  final String token;
  final UserBean userBean;
  final bool isGuide;
}

class RefreshAction {
  final RefreshStatus refreshStatus;
  final PageType type;

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
