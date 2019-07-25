import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/repos_detail_bloc.dart';
import 'package:open_git/bloc/repos_event_bloc.dart';
import 'package:open_git/bloc/repos_file_bloc.dart';
import 'package:open_git/bloc/repos_trend_bloc.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/fluro_convert_util.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/about_page.dart';
import 'package:open_git/ui/page/author_page.dart';
import 'package:open_git/ui/page/cache_page.dart';
import 'package:open_git/ui/page/guide/guide_page.dart';
import 'package:open_git/ui/page/issue_detail_page.dart';
import 'package:open_git/ui/page/language_page.dart';
import 'package:open_git/ui/page/login_page.dart';
import 'package:open_git/ui/page/main_page.dart';
import 'package:open_git/ui/page/other_page.dart';
import 'package:open_git/ui/page/repos_code_detail_page.dart';
import 'package:open_git/ui/page/repos_detail_page.dart';
import 'package:open_git/ui/page/repos_event_page.dart';
import 'package:open_git/ui/page/repos_file_page.dart';
import 'package:open_git/ui/page/repos_trend_page.dart';
import 'package:open_git/ui/page/search_page.dart';
import 'package:open_git/ui/page/setting_page.dart';
import 'package:open_git/ui/page/share_page.dart';
import 'package:open_git/ui/page/splash_page.dart';
import 'package:open_git/ui/page/theme_page.dart';
import 'package:open_git/ui/page/timeline_detail_page.dart';
import 'package:open_git/ui/page/timeline_page.dart';
import 'package:open_git/ui/page/trend_page.dart';
import 'package:open_git/ui/page/trending_page.dart';
import 'package:open_git/ui/page/user_profile_page.dart';
import 'package:redux/redux.dart';

var splashHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SplashPage();
});

var guideHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return GuidePage();
});

var mainHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MainPage();
});

var loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var settingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SettingPage();
});

var themeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ThemePage();
});

var languageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LanguagePage();
});

var webviewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;
  String isAd = params["isAd"]?.first;

  return WebViewPage(
    title: title,
    url: url,
    onWillPop: isAd == 'true'
        ? (context) {
            Store<AppState> store = StoreProvider.of(context);
            LoginStatus status = store.state.userState.status;
            if (store.state.userState.isGuide) {
              NavigatorUtil.goGuide(context);
            } else if (status == LoginStatus.success) {
              NavigatorUtil.goMain(context);
            } else if (status == LoginStatus.error) {
              NavigatorUtil.goLogin(context);
            }
          }
        : null,
  );
});

var aboutHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AboutPage();
});

var shareHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SharePage();
});

var timelineHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BlocProvider<TimelineBloc>(
    child: TimelinePage(),
    bloc: TimelineBloc(),
  );
});

var timelineDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String body = params["body"]?.first;
  return TimelineDetailPage(
    title: title,
    body: body,
  );
});

var trendHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TrendingPage();
});

var reposDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;
  return BlocProvider<ReposDetailBloc>(
    child: ReposDetailPage(),
    bloc: ReposDetailBloc(reposOwner, reposName),
  );
});

var reposEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposEventBloc>(
    child: ReposEventPage(),
    bloc: ReposEventBloc(reposOwner, reposName),
  );
});

var reposTrendHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String language = params["language"]?.first;

  return BlocProvider<ReposTrendBloc>(
    child: ReposTrendPage(),
    bloc: ReposTrendBloc(language),
  );
});

var reposFileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposFileBloc>(
    child: ReposFilePage(),
    bloc: ReposFileBloc(reposOwner, reposName),
  );
});

var reposCodeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return CodeDetailPageWeb(
    title: title,
    htmlUrl: url,
  );
});

var photoViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return PhotoViewPage(title, url);
});

var searchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SearchPage();
});

var authorHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AuthorPage();
});

var otherHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OtherPage();
});

var profileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;
  String avatar = params["avatar"]?.first;

  return UserProfilePage(name, avatar);
});

var issueDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  IssueDetailBloc bloc = IssueDetailBloc(
      IssueBean.fromJson(FluroConvertUtil.string2Map(params["issue"]?.first)));
  return BlocProvider<IssueDetailBloc>(
    child: IssueDetailPage(),
    bloc: bloc,
  );
});

var cacheHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CachePage();
});
