import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/routes.dart';
import 'package:open_git/ui/page/edit_issue_page.dart';
import 'package:open_git/ui/page/issue_detail_page.dart';
import 'package:open_git/ui/page/markdown_editor_page.dart';
import 'package:open_git/ui/page/reaction_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fluro_convert_util.dart';

class NavigatorUtil {
  //主页
  static goMain(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.main, replace: true);
  }

  //登录页
  static goLogin(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.login, replace: true);
  }

  //引导页
  static goGuide(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.guide, replace: true);
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
            "?reposOwner=${FluroConvertUtil.encode(reposOwner)}&reposName=${FluroConvertUtil.encode(reposName)}");
  }

  //趋势
  static goTrend(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.trend);
  }

  //仓库语言按star排名
  static goReposLanguage(BuildContext context, language) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_trend +
            "?language=${FluroConvertUtil.encode(language)}");
  }

  //仓库动态
  static goReposDynamic(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_event +
            "?reposOwner=${FluroConvertUtil.encode(reposOwner)}&reposName=${FluroConvertUtil.encode(reposName)}");
  }

  //用户资料
  static goUserProfile(BuildContext context, userBean) {
    String name = userBean.login;
    String avatar = userBean.avatarUrl;
    Application.router.navigateTo(
        context,
        AppRoutes.profile +
            "?name=${FluroConvertUtil.encode(name)}&avatar=${FluroConvertUtil.encode(avatar)}");
  }

  //查看源码文件目录
  static goReposSourceFile(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_file +
            "?reposOwner=${FluroConvertUtil.encode(reposOwner)}&reposName=${FluroConvertUtil.encode(reposName)}");
  }

  //查看源码
  static goReposSourceCode(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_code +
            "?title=${FluroConvertUtil.encode(title)}&url=${FluroConvertUtil.encode(url)}");
  }

  //搜索
  static goSearch(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.search);
  }

  //问题详情
  static goIssueDetail(BuildContext context, issueBean) {
//    String issue = FluroConvertUtil.object2String(issueBean.toJson);
//    Application.router
//        .navigateTo(context, AppRoutes.issue_detail + "?issue=$issue");

    IssueDetailBloc bloc = IssueDetailBloc(issueBean);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<IssueDetailBloc>(
          child: IssueDetailPage(),
          bloc: bloc,
        ),
      ),
    );
  }

  //评论编辑页
  static goMarkdownEditor(
      BuildContext context, issueBean, repoUrl, isAdd) async {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MarkdownEditorPage(
          issueBean,
          repoUrl,
          isAdd,
        ),
      ),
    );
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
        ),
      ),
    );
  }

  //问题编辑页
  static goEditIssue(BuildContext context, issueBean) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditIssuePage(
          issueBean: issueBean,
        ),
      ),
    );
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
            "?title=${FluroConvertUtil.encode(title)}&url=${FluroConvertUtil.encode(url)}");
  }

  static goWebViewForAd(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.webview +
            "?title=${FluroConvertUtil.encode(title)}&url=${FluroConvertUtil.encode(url)}&isAd=${FluroConvertUtil.encode(true.toString())}",
        replace: true);
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
            "?title=${FluroConvertUtil.encode(title)}&body=${FluroConvertUtil.encode(body)}");
  }

  //查看图片
  static goPhotoView(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.photo_view +
            "?title=${FluroConvertUtil.encode(title)}&url=${FluroConvertUtil.encode(url)}");
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
