import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData _themeData = new ThemeData.light();

  static get theme {
    return _themeData.copyWith(
      primaryColor: Colors.black,
    );
  }

  static ThemeData changeTheme(Color color) {
    return _themeData.copyWith(primaryColor: color);
  }
}
