import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/page/about_page.dart';
import 'package:open_git/page/introduction_detail_page.dart';
import 'package:open_git/page/introduction_page.dart';
import 'package:open_git/page/language_page.dart';
import 'package:open_git/page/login_page.dart';
import 'package:open_git/ui/main_page.dart';
import 'package:open_git/page/setting_page.dart';
import 'package:open_git/page/share_page.dart';
import 'package:open_git/ui/splash/splash_page.dart';
import 'package:open_git/page/theme_page.dart';
import 'package:open_git/page/web_view_page.dart';

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

var introductionHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new IntroductionPage();
});

var introductionDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String body = params["body"]?.first;
  return new IntroductionDetailPage(
    title: title,
    body: body,
  );
});
