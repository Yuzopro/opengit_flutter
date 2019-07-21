import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/route/route_handlers.dart';

class AppRoutes {
  static final splash = '/';
  static final guide = '/guide';
  static final main = '/main';
  static final login = '/login';
  static final setting = '/main/setting';
  static final theme = '/main/setting/theme';
  static final language = '/main/setting/language';
  static final webview = '/main/webview';
  static final about = '/main/about';
  static final share = '/main/share';
  static final timeline = '/main/about/timeline';
  static final timeline_detail = '/main/about/timeline/detail';
  static final trend = '/main/trend';
  static final repos_detail = '/main/repos/detail';
  static final repos_event = '/main/repos/event';
  static final repos_trend = '/main/repos/trend';
  static final repos_file = '/main/repos/file';
  static final repos_code = '/main/repos/code';
  static final photo_view = '/main/photo/view';
  static final search = '/main/searct';
  static final reaction = '/main/issue/reaction';
  static final author = '/main/author';
  static final other = '/main/other';
  static final profile = '/main/profile';
  static final issue_detail = '/main/issue/detail';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ROUTE WAS NOT FOUND !!!');
    });
    router.define(
      splash,
      handler: splashHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      guide,
      handler: guideHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      main,
      handler: mainHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      login,
      handler: loginHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      setting,
      handler: settingHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      theme,
      handler: themeHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      language,
      handler: languageHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      webview,
      handler: webviewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      about,
      handler: aboutHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      share,
      handler: shareHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      timeline,
      handler: timelineHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      timeline_detail,
      handler: timelineDetailHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      trend,
      handler: trendHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repos_detail,
      handler: reposDetailHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repos_event,
      handler: reposEventHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repos_trend,
      handler: reposTrendHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repos_file,
      handler: reposFileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repos_code,
      handler: reposCodeHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      photo_view,
      handler: photoViewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      search,
      handler: searchHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      author,
      handler: authorHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      other,
      handler: otherHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile,
      handler: profileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      issue_detail,
      handler: issueDetailHandler,
      transitionType: TransitionType.cupertino,
    );
  }
}
