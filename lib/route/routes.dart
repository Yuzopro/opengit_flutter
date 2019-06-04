import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/route/route_handlers.dart';

class AppRoutes {
  static final splash = "/";
  static final main = "/main";
  static final login = "/login";
  static final setting = "/main/setting";
  static final theme = "/main/setting/theme";
  static final language = "/main/setting/language";
  static final webview = "/main/webview";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(splash,
        handler: splashHandler, transitionType: TransitionType.inFromRight);
    router.define(main,
        handler: homeHandler, transitionType: TransitionType.inFromRight);
    router.define(login,
        handler: loginHandler, transitionType: TransitionType.inFromRight);
    router.define(setting,
        handler: settingHandler, transitionType: TransitionType.inFromRight);
    router.define(theme,
        handler: themeHandler, transitionType: TransitionType.inFromRight);
    router.define(language,
        handler: languageHandler, transitionType: TransitionType.inFromRight);
    router.define(webview,
        handler: webviewHandler, transitionType: TransitionType.inFromRight);
  }
}
