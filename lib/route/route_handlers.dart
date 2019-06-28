import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/ui/repos/repos_detail_page.dart';
import 'package:open_git/ui/repos/repos_event_page.dart';
import 'package:open_git/ui/repos/repos_source_code_page.dart';
import 'package:open_git/ui/repos/repos_source_file_page.dart';
import 'package:open_git/ui/repos/repos_trend_page.dart';
import 'package:open_git/ui/web_view_page.dart';
import 'package:open_git/ui/about/about_page.dart';
import 'package:open_git/ui/about/timeline_detail_page.dart';
import 'package:open_git/ui/about/timeline_page.dart';
import 'package:open_git/ui/login/login_page.dart';
import 'package:open_git/ui/main_page.dart';
import 'package:open_git/ui/setting/language_page.dart';
import 'package:open_git/ui/setting/setting_page.dart';
import 'package:open_git/ui/setting/theme_page.dart';
import 'package:open_git/ui/share/share_page.dart';
import 'package:open_git/ui/splash/splash_page.dart';
import 'package:open_git/ui/trend/trend_page.dart';

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
  return new TimelinePage();
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
  return new ReposDetailPage(
    reposOwner,
    reposName,
  );
});

var reposEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;
  return new ReposEventPage(
    reposOwner,
    reposName,
  );
});

var reposTrendHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String language = params["language"]?.first;
  return new ReposTrendPage(
    language,
  );
});

var reposFileHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;
  return new ReposSourceFilePage(
    reposOwner,
    reposName,
  );
});

var reposCodeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;
  return new ReposSourceCodePage(
    title,
    url,
  );
});
