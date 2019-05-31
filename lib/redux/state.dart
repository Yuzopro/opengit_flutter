import 'package:flutter/material.dart';

import '../theme.dart';

class AppState {
  ThemeData themeData;

  AppState({this.themeData});

  factory AppState.initial() => AppState(themeData: AppTheme.theme);
}
