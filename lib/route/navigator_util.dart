import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/routes.dart';
import 'package:open_git/ui/page/book_mark_page.dart';
import 'package:open_git/ui/page/edit_issue_page.dart';
import 'package:open_git/ui/page/issue_detail_page.dart';
import 'package:open_git/ui/page/login_page.dart';
import 'package:open_git/ui/page/main_page.dart';
import 'package:open_git/ui/page/markdown_editor_page.dart';
import 'package:open_git/ui/page/reaction_page.dart';
import 'package:open_git/ui/page/user_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  //主页
  static goMain(BuildContext context) {
//    Application.router.navigateTo(context, AppRoutes.main);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => MainPage()));
  }

  //登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginPage()));
  }

  //书签页
  static goBookMark(BuildContext context) {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => BookMarkPage()));
  }

  //设置页
  static goSetting(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.setting);
  }

  //关于页
  static goAbout(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.about);
  }

  //分享页
  static goShare(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.share);
  }

  //仓库详情
  static goReposDetail(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_detail +
            "?reposOwner=${Uri.encodeComponent(reposOwner)}&reposName=${Uri.encodeComponent(reposName)}");
  }

  //趋势
  static goTrend(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.trend);
  }

  //仓库语言按star排名
  static goReposLanguage(BuildContext context, language) {
    Application.router.navigateTo(context,
        AppRoutes.repos_trend + "?language=${Uri.encodeComponent(language)}");
  }

  //仓库动态
  static goReposDynamic(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_event +
            "?reposOwner=${Uri.encodeComponent(reposOwner)}&reposName=${Uri.encodeComponent(reposName)}");
  }

  //用户资料
  static goUserProfile(BuildContext context, userBean) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => UserProfilePage(userBean)));
  }

  //查看源码文件目录
  static goReposSourceFile(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_file +
            "?reposOwner=${Uri.encodeComponent(reposOwner)}&reposName=${Uri.encodeComponent(reposName)}");
  }

  //查看源码
  static goReposSourceCode(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_code +
            "?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}");
  }

  //搜索
  static goSearch(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.search);
  }

  //问题详情
  static goIssueDetail(BuildContext context, issueBean) {
    IssueDetailBloc bloc = IssueDetailBloc(issueBean);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider<IssueDetailBloc>(
                  child: IssueDetailPage(),
                  bloc: bloc,
                )));
  }

  //评论编辑页
  static goMarkdownEditor(
      BuildContext context, issueBean, repoUrl, isAdd) async {
    return Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                MarkdownEditorPage(issueBean, repoUrl, isAdd)));
  }

  //评论编辑页
  static goDeleteReaction(
      BuildContext context, issueBean, repoUrl, content, isIssue) async {
    ReactionBloc bloc = ReactionBloc(issueBean, repoUrl, content, isIssue);
    return Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider<ReactionBloc>(
                  child: ReactionPage(),
                  bloc: bloc,
                )));
  }

  //问题编辑页
  static goEditIssue(BuildContext context, issueBean, repoUrl) {
    return Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditIssuePage(
                  issueBean: issueBean,
                  repoUrl: repoUrl,
                )));
  }

  //主题页
  static goTheme(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.theme);
  }

  //语言切换页
  static goLanguage(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.language);
  }

  //h5页面
  static goWebView(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.webview +
            "?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}");
  }

  //功能介绍页
  static goTimeline(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.timeline);
  }

  //功能介绍详情页
  static goTimelineDetail(BuildContext context, title, body) {
    Application.router.navigateTo(
        context,
        AppRoutes.timeline_detail +
            "?title=${Uri.encodeComponent(title)}&body=${Uri.encodeComponent(body)}");
  }

  //查看图片
  static goPhotoView(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.photo_view +
            "?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}");
  }

  //作者
  static goAuthor(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.author);
  }

  //其他
  static goOther(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.other);
  }

  //系统浏览器
  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
