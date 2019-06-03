import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_git/page/app_info_page.dart';
import 'package:open_git/page/book_mark_page.dart';
import 'package:open_git/page/delete_reaction_page.dart';
import 'package:open_git/page/edit_issue_page.dart';
import 'package:open_git/page/issue_detail_page.dart';
import 'package:open_git/page/logout_page.dart';
import 'package:open_git/page/markdown_editor_page.dart';
import 'package:open_git/page/repository_contributor_page.dart';
import 'package:open_git/page/repository_detail_page.dart';
import 'package:open_git/page/repository_event_page.dart';
import 'package:open_git/page/repository_language_page.dart';
import 'package:open_git/page/repository_source_code_page.dart';
import 'package:open_git/page/repository_source_file_page.dart';
import 'package:open_git/page/repository_trending_page.dart';
import 'package:open_git/page/search_page.dart';
import 'package:open_git/page/share_page.dart';
import 'package:open_git/page/trend_page.dart';
import 'package:open_git/page/user_profile_page.dart';
import 'package:open_git/route/routes.dart';

class NavigatorUtil {
  //主页
  static goMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  //登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
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
    Navigator.pushNamed(context, AppRoutes.setting);
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
  static goReposDetail(
      BuildContext context, reposOwner, reposName, isJumpTrending) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new RepositoryDetailPage(
                reposOwner, reposName, isJumpTrending)));
  }

  //趋势
  static goReposTrending(BuildContext context, language) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new RepositoryTrendingPage(language)));
  }

  //仓库语言按star排名
  static goReposLanguage(BuildContext context, language) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new RepositoryLanguagePage(language)));
  }

  //仓库动态
  static goReposDynamic(BuildContext context, reposOwner, reposName) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) =>
                new RepositoryEventPage(reposOwner, reposName)));
  }

  //仓库贡献者
  static goReposContributor(BuildContext context) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new RepositoryContributorPage()));
  }

  //用户资料
  static goUserProfile(BuildContext context, userBean) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new UserProfilePage(userBean)));
  }

  //查看源码文件目录
  static goReposSourceFile(BuildContext context, reposOwner, reposName) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) =>
                new RepositorySourceFilePage(reposOwner, reposName)));
  }

  //查看源码
  static goReposSourceCode(BuildContext context, title, url) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new RepositorySourceCodePage(title, url)));
  }

  //搜索
  static goSearch(BuildContext context) {
    Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => new SearchPage()));
  }

  //问题详情
  static goIssueDetail(BuildContext context, issueBean) {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new IssueDetailPage(issueBean)));
  }

  //评论编辑页
  static goMarkdownEditor(
      BuildContext context, issueBean, repoUrl, isAdd) async {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) =>
                new MarkdownEditorPage(issueBean, repoUrl, isAdd)));
  }

  //评论编辑页
  static goDeleteReaction(
      BuildContext context, issueBean, repoUrl, content, isIssue) async {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) =>
                new DeleteReactionPage(issueBean, repoUrl, content, isIssue)));
  }

  //问题编辑页
  static goEditIssue(BuildContext context, issueBean, repoUrl) {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => new EditIssuePage(
                  issueBean: issueBean,
                  repoUrl: repoUrl,
                )));
  }

  //主题页
  static goTheme(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.theme);
  }

  //语言切换页
  static goLanguage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.language);
  }
}
