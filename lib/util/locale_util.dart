import 'package:flutter/material.dart';

class LocaleUtil {
  static Locale changeLocale(int index) {
    Locale locale;
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