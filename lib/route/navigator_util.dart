import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bloc/contributor_bloc.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/label_bloc.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/bloc/repo_fork_bloc.dart';
import 'package:open_git/bloc/repo_issue_bloc.dart';
import 'package:open_git/bloc/stargazer_bloc.dart';
import 'package:open_git/bloc/subscriber_bloc.dart';
import 'package:open_git/bloc/trending_language_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/routes.dart';
import 'package:open_git/ui/page/issue/edit_comment_page.dart';
import 'package:open_git/ui/page/issue/edit_issue_page.dart';
import 'package:open_git/ui/page/issue/edit_label_page.dart';
import 'package:open_git/ui/page/issue/issue_detail_page.dart';
import 'package:open_git/ui/page/issue/label_page.dart';
import 'package:open_git/ui/page/issue/reaction_page.dart';
import 'package:open_git/ui/page/profile/edit_profile_page.dart';
import 'package:open_git/ui/page/repo/contributor_page.dart';
import 'package:open_git/ui/page/repo/repo_fork_page.dart';
import 'package:open_git/ui/page/repo/repo_issue_page.dart';
import 'package:open_git/ui/page/repo/stargazer_page.dart';
import 'package:open_git/ui/page/repo/subscriber_page.dart';
import 'package:open_git/ui/page/trending/trending_date_page.dart';
import 'package:open_git/ui/page/trending/trending_language_page.dart';
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
  static goUserProfile(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.profile + "?name=${FluroConvertUtil.encode(name)}");
  }

  //查看源码文件目录
  static goReposSourceFile(
      BuildContext context, reposOwner, reposName, branch) {
    Application.router.navigateTo(
        context,
        AppRoutes.repos_file +
            "?reposOwner=${FluroConvertUtil.encode(reposOwner)}"
                "&reposName=${FluroConvertUtil.encode(reposName)}"
                "&branch=${FluroConvertUtil.encode(branch)}");
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
        builder: (context) => EditCommentPage(
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

  //缓存设置
  static goCache(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.cache);
  }

  //趋势周期
  static goTrendingDate(BuildContext context) async {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TrendingDatePage(),
      ),
    );
  }

  //趋势语言
  static goTrendingLanguage(BuildContext context) async {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<TrendingLanguageBloc>(
          child: TrendingLanguagePage(),
          bloc: TrendingLanguageBloc(),
        ),
      ),
    );
  }

  //资料项目
  static goProfileRepos(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_repos + "?name=${FluroConvertUtil.encode(name)}");
  }

  //资料star项目
  static goProfileStarRepos(BuildContext context, name) {
    Application.router.navigateTo(
        context,
        AppRoutes.profile_star_repos +
            "?name=${FluroConvertUtil.encode(name)}");
  }

  //资料关注我的
  static goProfileFollower(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_follower + "?name=${FluroConvertUtil.encode(name)}");
  }

  //资料我关注的
  static goProfileFollowing(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_following + "?name=${FluroConvertUtil.encode(name)}");
  }

  //资料组织
  static goProfileOrg(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_org + "?name=${FluroConvertUtil.encode(name)}");
  }

  //资料动态
  static goProfileEvent(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_event + "?name=${FluroConvertUtil.encode(name)}");
  }

  //组织资料
  static goOrgProfile(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.org_profile + "?name=${FluroConvertUtil.encode(name)}");
  }

  //组织动态
  static goOrgEvent(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.org_event + "?name=${FluroConvertUtil.encode(name)}");
  }

  //组织项目
  static goOrgRepos(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.org_repos + "?name=${FluroConvertUtil.encode(name)}");
  }

  //组织成员
  static goOrgMember(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.org_member + "?name=${FluroConvertUtil.encode(name)}");
  }

  //标签
  static goLabel(
      BuildContext context, repo, List<Labels> labels, issueNum) async {
    LabelBloc bloc = LabelBloc(repo, labels, issueNum);

    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<LabelBloc>(
          child: LabelPage(),
          bloc: bloc,
        ),
      ),
    );
  }

  //组织成员
  static goEditLabel(BuildContext context, Labels label, String repo) async {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditLabelPage(
          item: label,
          repo: repo,
        ),
      ),
    );
  }

  static goRepoContributor(BuildContext context, url) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<UserBloc>(
          child: ContributorPage(),
          bloc: ContributorBloc(url),
        ),
      ),
    );
  }

  static goRepoStargazer(BuildContext context, url) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<UserBloc>(
          child: StargazerPage(),
          bloc: StargazerBloc(url),
        ),
      ),
    );
  }

  static goRepoSubscriber(BuildContext context, url) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<UserBloc>(
          child: SubscriberPage(),
          bloc: SubscriberBloc(url),
        ),
      ),
    );
  }

  static goRepoIssue(BuildContext context, owner, repo) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<RepoIssueBloc>(
          child: RepoIssuePage(),
          bloc: RepoIssueBloc(owner, repo),
        ),
      ),
    );
  }

  static goRepoFork(BuildContext context, owner, repo) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<UserBloc>(
          child: RepoForkPage(),
          bloc: RepoForkBloc(owner, repo),
        ),
      ),
    );
  }

  static goEditProfile(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );
  }
}
