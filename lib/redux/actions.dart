import 'package:flutter/material.dart';

//刷新主题
class RefreshThemeDataAction{
  final ThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}

//刷新语言
class RefreshLocalAction{
  final Locale locale;

  RefreshLocalAction(this.locale);
}