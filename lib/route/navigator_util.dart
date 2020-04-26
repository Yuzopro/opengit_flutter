import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/label_bloc.dart';
import 'package:open_git/bloc/track_bloc.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/fluro_util.dart';
import 'package:open_git/route/routes.dart';
import 'package:open_git/ui/page/issue/edit_label_page.dart';
import 'package:open_git/ui/page/issue/issue_detail_page.dart';
import 'package:open_git/ui/page/issue/label_page.dart';
import 'package:open_git/ui/page/other/track_page.dart';
import 'package:open_git/ui/page/profile/org_profile_new_page.dart';
import 'package:open_git/ui/page/profile/user_profile_new_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String owner = FluroUtil.encode(reposOwner);
    String repo = FluroUtil.encode(reposName);

    Application.router.navigateTo(
        context, AppRoutes.repo_detail + "?reposOwner=$owner&reposName=$repo");
  }

  //趋势
  static goTrend(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.trend);
  }

  //仓库语言按star排名
  static goReposLanguage(BuildContext context, language) {
    Application.router.navigateTo(context,
        AppRoutes.repo_trend + "?language=${FluroUtil.encode(language)}");
  }

  //仓库动态
  static goReposDynamic(BuildContext context, reposOwner, reposName) {
    Application.router.navigateTo(
        context,
        AppRoutes.repo_event +
            "?reposOwner=${FluroUtil.encode(reposOwner)}&reposName=${FluroUtil.encode(reposName)}");
  }

  //用户资料
  static goUserProfile(BuildContext context, name, avatar, heroTag) {
//    Application.router.navigateTo(
//        context, AppRoutes.profile + "?name=${FluroUtil.encode(name)}");
    goProfile(context, name, avatar, heroTag);
  }

  //查看源码文件目录
  static goReposSourceFile(
      BuildContext context, reposOwner, reposName, branch) {
    Application.router.navigateTo(
        context,
        AppRoutes.repo_file +
            "?reposOwner=${FluroUtil.encode(reposOwner)}"
                "&reposName=${FluroUtil.encode(reposName)}"
                "&branch=${FluroUtil.encode(branch)}");
  }

  //查看源码
  static goReposSourceCode(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.repo_code +
            "?title=${FluroUtil.encode(title)}&url=${FluroUtil.encode(url)}");
  }

  //搜索
  static goSearch(BuildContext context) {
    Application.router.navigateTo(context, AppRoutes.search);
  }

  //问题详情
  static goIssueDetail(BuildContext context, IssueBean issueBean) {
    //用fluro路由实现，当键盘状态改变时，会导致页面的刷新
//    String issue = FluroUtil.object2String(issueBean.toJson);
//    Application.router
//        .navigateTo(context, AppRoutes.issue_detail + "?issue=$issue");

    IssueDetailBloc bloc =
        IssueDetailBloc(issueBean.repoUrl, issueBean.number.toString());
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
  static goEditIssueComment(
      BuildContext context, IssueBean issueBean, repoUrl, isAdd) async {
    String body = FluroUtil.encode(issueBean.body);
    String url = FluroUtil.encode(repoUrl);
    String isAddStr = FluroUtil.encode(isAdd.toString());
    int id = isAdd ? issueBean.number : issueBean.id;

    return Application.router.navigateTo(
        context,
        AppRoutes.edit_issue_comment +
            "?url=$url&body=$body&id=${FluroUtil.encode(id.toString())}&isAdd=$isAddStr");
  }

  //评论编辑页
  static goDeleteReaction(
      BuildContext context, repoUrl, content, isIssue, int id) async {
    String url = FluroUtil.encode(repoUrl);
    String idStr = FluroUtil.encode(id.toString());
    String isIssueStr = FluroUtil.encode(isIssue.toString());

    return Application.router.navigateTo(
        context,
        AppRoutes.edit_issue_reaction +
            "?url=$url&content=${FluroUtil.encode(content)}&isIssue=$isIssueStr&id=$idStr");
  }

  //问题编辑页
  static goEditIssue(BuildContext context, IssueBean issueBean) {
    String title = FluroUtil.encode(issueBean.title);
    String body = FluroUtil.encode(issueBean.body);
    String url = FluroUtil.encode(issueBean.repoUrl);
    String num = FluroUtil.encode(issueBean.number.toString());

    return Application.router.navigateTo(context,
        AppRoutes.edit_issue + "?title=$title&body=$body&url=$url&num=$num");
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
            "?title=${FluroUtil.encode(title)}&url=${FluroUtil.encode(url)}");
  }

  static goWebViewForAd(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.webview +
            "?title=${FluroUtil.encode(title)}&url=${FluroUtil.encode(url)}&isAd=${FluroUtil.encode(true.toString())}",
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
            "?title=${FluroUtil.encode(title)}&body=${FluroUtil.encode(body)}");
  }

  //查看图片
  static goPhotoView(BuildContext context, title, url) {
    Application.router.navigateTo(
        context,
        AppRoutes.photo_view +
            "?title=${FluroUtil.encode(title)}&url=${FluroUtil.encode(url)}");
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
    return Application.router.navigateTo(context, AppRoutes.trend_date);
  }

  //趋势语言
  static goTrendingLanguage(BuildContext context) async {
    return Application.router.navigateTo(context, AppRoutes.trend_language);
  }

  //资料项目
  static goProfileRepos(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.profile_repos + "?name=${FluroUtil.encode(name)}");
  }

  //资料star项目
  static goProfileStarRepos(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_star_repos + "?name=${FluroUtil.encode(name)}");
  }

  //资料关注我的
  static goProfileFollower(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_follower + "?name=${FluroUtil.encode(name)}");
  }

  //资料我关注的
  static goProfileFollowing(BuildContext context, name) {
    Application.router.navigateTo(context,
        AppRoutes.profile_following + "?name=${FluroUtil.encode(name)}");
  }

  //资料组织
  static goProfileOrg(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.profile_org + "?name=${FluroUtil.encode(name)}");
  }

  //资料动态
  static goProfileEvent(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.profile_event + "?name=${FluroUtil.encode(name)}");
  }

  //组织资料
  static goOrgProfile(BuildContext context, name, avatar) {
//    Application.router.navigateTo(
//        context, AppRoutes.org_profile + "?name=${FluroUtil.encode(name)}");

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => OrgProfilePage(
          name: name,
          avatar: avatar,
        ),
      ),
    );
  }

  //组织动态
  static goOrgEvent(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.org_event + "?name=${FluroUtil.encode(name)}");
  }

  //组织项目
  static goOrgRepos(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.org_repos + "?name=${FluroUtil.encode(name)}");
  }

  //组织成员
  static goOrgMember(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.org_member + "?name=${FluroUtil.encode(name)}");
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

  //编辑标签
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
    Application.router.navigateTo(
        context, AppRoutes.repo_contributor + "?url=${FluroUtil.encode(url)}");
  }

  static goRepoStargazer(BuildContext context, url) {
    Application.router.navigateTo(
        context, AppRoutes.repo_stargazer + "?url=${FluroUtil.encode(url)}");
  }

  static goRepoSubscriber(BuildContext context, url) {
    Application.router.navigateTo(
        context, AppRoutes.repo_subscriber + "?url=${FluroUtil.encode(url)}");
  }

  static goRepoIssue(BuildContext context, owner, repo) {
    Application.router.navigateTo(
        context,
        AppRoutes.repo_issue +
            "?owner=${FluroUtil.encode(owner)}&repo=${FluroUtil.encode(repo)}");
  }

  static goRepoFork(BuildContext context, owner, repo) {
    Application.router.navigateTo(
        context,
        AppRoutes.repo_fork +
            "?owner=${FluroUtil.encode(owner)}&repo=${FluroUtil.encode(repo)}");
  }

  static goEditProfile(BuildContext context) async {
    return Application.router.navigateTo(context, AppRoutes.edit_profile);
  }

  static goTrack(BuildContext context) async {
    TrackBloc bloc = TrackBloc();

    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<TrackBloc>(
          child: TrackPage(),
          bloc: bloc,
        ),
      ),
    );
  }

  //项目topic
  static goReposTopic(BuildContext context, name) {
    Application.router.navigateTo(
        context, AppRoutes.repo_topic + "?name=${FluroUtil.encode(name)}");
  }

  //资料页
  static goProfile(BuildContext context, name, avatar, heroTag) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UserProfilePage(
          name: name,
          avatar: avatar,
          heroTag: heroTag,
        ),
      ),
    );
  }
}
