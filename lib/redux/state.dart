import 'package:flutter/material.dart';
import 'package:open_git/util/theme_util.dart';

class AppState {
  //主题
  ThemeData themeData;

  //语言
  Locale locale;

  //系统语言
  Locale platformLocale;

  AppState({this.themeData, this.locale});

  factory AppState.initial() =>
      AppState(themeData: AppTheme.theme, locale: Locale('zh', 'CH'));
}
