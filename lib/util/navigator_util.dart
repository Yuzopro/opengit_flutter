import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_git/page/app_info_page.dart';
import 'package:open_git/page/book_mark_page.dart';
import 'package:open_git/page/login_page.dart';
import 'package:open_git/page/logout_page.dart';
import 'package:open_git/page/main_page.dart';
import 'package:open_git/page/repository_contributor_page.dart';
import 'package:open_git/page/repository_detail_page.dart';
import 'package:open_git/page/repository_event_page.dart';
import 'package:open_git/page/repository_trending_page.dart';
import 'package:open_git/page/setting_page.dart';
import 'package:open_git/page/share_page.dart';
import 'package:open_git/page/trend_page.dart';

class NavigatorUtil {
  //主页
  static goMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, MainPage.sName);
  }

  //登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  //趋势页
  static goTrend(BuildContext context) {
    Navigator.push(
        context, new CupertinoPageRoute(builder: (context) => new TrendPage()));
  }

  //书签页
  static goBookMark(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new BookMarkPage()));
  }

  //设置页
  static goSetting(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new SettingPage()));
  }

  //关于页
  static goAppInfo(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new AppInfoPage()));
  }

  //分享页
  static goShare(BuildContext context) {
    Navigator.push(
        context, new CupertinoPageRoute(builder: (context) => new SharePage()));
  }

  //注销页
  static goLogout(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new LogoutPage()));
  }

  ///仓库详情
  static goReposDetail(BuildContext context, reposOwner, reposName) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) =>
                new RepositoryDetailPage(reposOwner, reposName)));
  }

  //仓库语言
  static goReposLanguage(BuildContext context, language) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new RepositoryTrendingPage(language)));
  }

  //仓库动态
  static goReposDynamic(BuildContext context, reposOwner, reposName) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new RepositoryEventPage(reposOwner, reposName)));
  }

  //仓库贡献者
  static goReposContributor(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new RepositoryContributorPage()));
  }
}
