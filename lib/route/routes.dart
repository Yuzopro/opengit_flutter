import 'package:flutter/material.dart';
import 'package:open_git/page/login_page.dart';
import 'package:open_git/page/main_page.dart';
import 'package:open_git/page/setting_page.dart';
import 'package:open_git/page/splash_page.dart';
import 'package:open_git/page/theme_select_page.dart';

class AppRoutes {
  static final splash = "/";
  static final home = "/home";
  static final login = "/login";
  static final setting = "/home/setting";
  static final theme = "/home/setting/theme";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) {
        return new SplashPage();
      },
      AppRoutes.login: (context) {
        return new LoginPage();
      },
      AppRoutes.home: (context) {
        return new MainPage();
      },
      AppRoutes.setting: (context) {
        return new SettingPage();
      },
      AppRoutes.theme: (context) {
        return new ThemeSelectPage();
      },
    };
  }
}
