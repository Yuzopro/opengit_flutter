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
  static final about = "/main/about";
  static final share = "/main/share";
  static final timeline = "/main/about/timeline";
  static final timeline_detail = "/main/about/timeline/detail";
  static final trend = "/main/trend";
  static final repos_detail = "/main/repos/detail";
  static final repos_event = "/main/repos/event";
  static final repos_trend = "/main/repos/trend";
  static final repos_file = "/main/repos/file";
  static final repos_code = "/main/repos/code";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(splash,
        handler: splashHandler, transitionType: TransitionType.inFromRight);
    router.define(main,
        handler: mainHandler, transitionType: TransitionType.inFromRight);
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
    router.define(about,
        handler: aboutHandler, transitionType: TransitionType.inFromRight);
    router.define(share,
        handler: shareHandler, transitionType: TransitionType.inFromRight);
    router.define(timeline,
        handler: timelineHandler, transitionType: TransitionType.inFromRight);
    router.define(timeline_detail,
        handler: timelineDetailHandler,
        transitionType: TransitionType.inFromRight);
    router.define(trend,
        handler: trendHandler, transitionType: TransitionType.inFromRight);
    router.define(repos_detail,
        handler: reposDetailHandler,
        transitionType: TransitionType.inFromRight);
    router.define(repos_event,
        handler: reposEventHandler, transitionType: TransitionType.inFromRight);
    router.define(repos_trend,
        handler: reposTrendHandler, transitionType: TransitionType.inFromRight);
    router.define(repos_file,
        handler: reposFileHandler, transitionType: TransitionType.inFromRight);
    router.define(repos_code,
        handler: reposCodeHandler, transitionType: TransitionType.inFromRight);
  }
}
