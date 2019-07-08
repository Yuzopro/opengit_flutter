import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/repos_detail_bloc.dart';
import 'package:open_git/bloc/repos_event_bloc.dart';
import 'package:open_git/bloc/repos_file_bloc.dart';
import 'package:open_git/bloc/repos_trend_bloc.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/ui/page/about_page.dart';
import 'package:open_git/ui/page/author_page.dart';
import 'package:open_git/ui/page/language_page.dart';
import 'package:open_git/ui/page/login_page.dart';
import 'package:open_git/ui/page/main_page.dart';
import 'package:open_git/ui/page/other_page.dart';
import 'package:open_git/ui/page/photoview_page.dart';
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
import 'package:open_git/ui/page/web_view_page.dart';

var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SplashPage();
});

var mainHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new MainPage();
});

var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginPage();
});

var settingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SettingPage();
});

var themeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new ThemePage();
});

var languageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LanguagePage();
});

var webviewHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;
  return new WebViewPage(
    title: title,
    url: url,
  );
});

var aboutHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new AboutPage();
});

var shareHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SharePage();
});

var timelineHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BlocProvider<TimelineBloc>(
    child: TimelinePage(),
    bloc: TimelineBloc(),
  );
});

var timelineDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String body = params["body"]?.first;
  return new TimelineDetailPage(
    title: title,
    body: body,
  );
});

var trendHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new TrendPage();
});

var reposDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;
  return BlocProvider<ReposDetailBloc>(
    child: ReposDetailPage(),
    bloc: ReposDetailBloc(reposOwner, reposName),
  );
});

var reposEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposEventBloc>(
    child: ReposEventPage(),
    bloc: ReposEventBloc(reposOwner, reposName),
  );
});

var reposTrendHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String language = params["language"]?.first;

  return BlocProvider<ReposTrendBloc>(
    child: ReposTrendPage(),
    bloc: ReposTrendBloc(language),
  );
});

var reposFileHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposFileBloc>(
    child: ReposFilePage(),
    bloc: ReposFileBloc(reposOwner, reposName),
  );
});

var reposCodeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return CodeDetailPageWeb(
    title: title,
    htmlUrl: url,
  );
});

var photoViewHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return PhotoViewPage(title, url);
});

var searchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SearchPage();
});

var authorHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new AuthorPage();
});

var otherHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new OtherPage();
});
