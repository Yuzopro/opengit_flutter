import 'package:flutter/material.dart';
import 'package:open_git/redux/state.dart';

class LocaleUtil {
  static Locale changeLocale(AppState state, int index) {
    Locale locale = state.platformLocale;
    switch (index) {
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    return locale;
  }
}