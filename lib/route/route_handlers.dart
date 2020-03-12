import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bloc/contributor_bloc.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/org_bloc.dart';
import 'package:open_git/bloc/org_event_bloc.dart';
import 'package:open_git/bloc/org_member_bloc.dart';
import 'package:open_git/bloc/org_profile_bloc.dart';
import 'package:open_git/bloc/org_repo_bloc.dart';
import 'package:open_git/bloc/profile_bloc.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/bloc/repo_detail_bloc.dart';
import 'package:open_git/bloc/repo_event_bloc.dart';
import 'package:open_git/bloc/repo_file_bloc.dart';
import 'package:open_git/bloc/repo_fork_bloc.dart';
import 'package:open_git/bloc/repo_issue_bloc.dart';
import 'package:open_git/bloc/repo_trend_bloc.dart';
import 'package:open_git/bloc/repo_user_bloc.dart';
import 'package:open_git/bloc/repo_user_star_bloc.dart';
import 'package:open_git/bloc/stargazer_bloc.dart';
import 'package:open_git/bloc/subscriber_bloc.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/bloc/trending_language_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/bloc/user_event_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/fluro_util.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/guide/guide_page.dart';
import 'package:open_git/ui/page/guide/splash_page.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/home/main_page.dart';
import 'package:open_git/ui/page/home/repo_page.dart';
import 'package:open_git/ui/page/home/search_page.dart';
import 'package:open_git/ui/page/issue/edit_comment_page.dart';
import 'package:open_git/ui/page/issue/edit_issue_page.dart';
import 'package:open_git/ui/page/issue/reaction_page.dart';
import 'package:open_git/ui/page/login/login_page.dart';
import 'package:open_git/ui/page/other/about_page.dart';
import 'package:open_git/ui/page/other/author_page.dart';
import 'package:open_git/ui/page/other/cache_page.dart';
import 'package:open_git/ui/page/other/language_page.dart';
import 'package:open_git/ui/page/other/other_page.dart';
import 'package:open_git/ui/page/other/setting_page.dart';
import 'package:open_git/ui/page/other/share_page.dart';
import 'package:open_git/ui/page/other/theme_page.dart';
import 'package:open_git/ui/page/other/timeline_detail_page.dart';
import 'package:open_git/ui/page/other/timeline_page.dart';
import 'package:open_git/ui/page/profile/edit_profile_page.dart';
import 'package:open_git/ui/page/profile/follower_page.dart';
import 'package:open_git/ui/page/profile/following_page.dart';
import 'package:open_git/ui/page/profile/org_member_page.dart';
import 'package:open_git/ui/page/profile/org_profile_page.dart';
import 'package:open_git/ui/page/profile/user_org_page.dart';
import 'package:open_git/ui/page/profile/user_profile_page.dart';
import 'package:open_git/ui/page/repo/contributor_page.dart';
import 'package:open_git/ui/page/repo/repo_code_detail_page.dart';
import 'package:open_git/ui/page/repo/repo_detail_page.dart';
import 'package:open_git/ui/page/repo/repo_event_page.dart';
import 'package:open_git/ui/page/repo/repo_file_page.dart';
import 'package:open_git/ui/page/repo/repo_fork_page.dart';
import 'package:open_git/ui/page/repo/repo_issue_page.dart';
import 'package:open_git/ui/page/repo/repo_trend_page.dart';
import 'package:open_git/ui/page/repo/stargazer_page.dart';
import 'package:open_git/ui/page/repo/subscriber_page.dart';
import 'package:open_git/ui/page/trending/trending_date_page.dart';
import 'package:open_git/ui/page/trending/trending_language_page.dart';
import 'package:open_git/ui/page/trending/trending_page.dart';
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
//    return CanvasDemo();
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
  String title = FluroUtil.decode(params["title"]?.first);
  String url = FluroUtil.decode(params["url"]?.first);
  String isAd = FluroUtil.decode(params["isAd"]?.first);

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
  String title = FluroUtil.decode(params["title"]?.first);
  String body = FluroUtil.decode(params["body"]?.first);
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
  String reposOwner = FluroUtil.decode(params["reposOwner"]?.first);
  String reposName = FluroUtil.decode(params["reposName"]?.first);
  return BlocProvider<RepoDetailBloc>(
    child: RepoDetailPage(),
    bloc: RepoDetailBloc(reposOwner, reposName),
  );
});

var reposEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = FluroUtil.decode(params["reposOwner"]?.first);
  String reposName = FluroUtil.decode(params["reposName"]?.first);

  return BlocProvider<RepoEventBloc>(
    child: RepoEventPage(),
    bloc: RepoEventBloc(reposOwner, reposName),
  );
});

var reposTrendHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String language = FluroUtil.decode(params["language"]?.first);

  return BlocProvider<RepoTrendBloc>(
    child: RepoTrendPage(),
    bloc: RepoTrendBloc(language),
  );
});

var reposFileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = FluroUtil.decode(params["reposOwner"]?.first);
  String reposName = FluroUtil.decode(params["reposName"]?.first);
  String branch = FluroUtil.decode(params["branch"]?.first);

  return BlocProvider<RepoFileBloc>(
    child: RepoFilePage(),
    bloc: RepoFileBloc(reposOwner, reposName, branch),
  );
});

var reposCodeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = FluroUtil.decode(params["title"]?.first);
  String url = FluroUtil.decode(params["url"]?.first);

  return CodeDetailPageWeb(
    title: title,
    htmlUrl: url,
  );
});

var photoViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = FluroUtil.decode(params["title"]?.first);
  String url = FluroUtil.decode(params["url"]?.first);

  return PhotoViewPage(title, url, ImagePath.image_default_head);
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
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<ProfileBloc>(
    child: UserProfilePage(),
    bloc: ProfileBloc(name),
  );
});

var issueDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//  IssueDetailBloc bloc = IssueDetailBloc(
//      IssueBean.fromJson(FluroUtil.string2Map(params["issue"]?.first)));
//  return BlocProvider<IssueDetailBloc>(
//    child: IssueDetailPage(),
//    bloc: bloc,
//  );
});

var cacheHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CachePage();
});

var profileReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<RepoBloc>(
    child: RepoPage(RepoPage.PAGE_USER),
    bloc: RepoUserBloc(name),
  );
});

var profileStarReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<RepoBloc>(
    child: RepoPage(RepoPage.PAGE_USER_STAR),
    bloc: RepoUserStarBloc(name),
  );
});

var profileFollowerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<UserBloc>(
    child: FollowerPage(),
    bloc: FollowersBloc(name),
  );
});

var profileFollowingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<UserBloc>(
    child: FollowingPage(),
    bloc: FollowingBloc(name),
  );
});

var profileOrgHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<OrgBloc>(
    child: OrgPage(),
    bloc: OrgBloc(name),
  );
});

var profileEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<EventBloc>(
    child: EventPage(true),
    bloc: UserEventBloc(name),
  );
});

var orgProfileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<OrgProfileBloc>(
    child: OrgProfilePage(),
    bloc: OrgProfileBloc(name),
  );
});

var orgEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<EventBloc>(
    child: EventPage(true),
    bloc: OrgEventBloc(name),
  );
});

var orgReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<RepoBloc>(
    child: RepoPage(RepoPage.PAGE_ORG),
    bloc: RepoOrgBloc(name),
  );
});

var orgMemberHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = FluroUtil.decode(params["name"]?.first);

  return BlocProvider<UserBloc>(
    child: OrgMemberPage(),
    bloc: OrgMemberBloc(name),
  );
});

var issueLabelHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//  String name = params["name"]?.first;
//  String repo = FluroConvertUtil.fluroCnParamsDecode(params["repo"]?.first);
//
//  return BlocProvider<LabelBloc>(
//    child: LabelPage(),
//    bloc: LabelBloc(name, repo),
//  );
});
var repoContributorHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = FluroUtil.decode(params["url"]?.first);

  return BlocProvider<UserBloc>(
    child: ContributorPage(),
    bloc: ContributorBloc(url),
  );
});

var repoStargazerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = FluroUtil.decode(params["url"]?.first);

  return BlocProvider<UserBloc>(
    child: StargazerPage(),
    bloc: StargazerBloc(url),
  );
});

var repoSubscriberHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = FluroUtil.decode(params["url"]?.first);

  return BlocProvider<UserBloc>(
    child: SubscriberPage(),
    bloc: SubscriberBloc(url),
  );
});

var repoIssueHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String owner = FluroUtil.decode(params["owner"]?.first);
  String repo = FluroUtil.decode(params["repo"]?.first);

  return BlocProvider<RepoIssueBloc>(
    child: RepoIssuePage(),
    bloc: RepoIssueBloc(owner, repo),
  );
});

var repoForkHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String owner = FluroUtil.decode(params["owner"]?.first);
  String repo = FluroUtil.decode(params["repo"]?.first);

  return BlocProvider<UserBloc>(
    child: RepoForkPage(),
    bloc: RepoForkBloc(owner, repo),
  );
});

var trendDateHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TrendingDatePage();
});

var trendLanguageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BlocProvider<TrendingLanguageBloc>(
    child: TrendingLanguagePage(),
    bloc: TrendingLanguageBloc(),
  );
});

var editProfileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditProfilePage();
});

var editIssueHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = FluroUtil.decode(params["title"]?.first);
  String body = FluroUtil.decode(params["body"]?.first);
  String url = FluroUtil.decode(params["url"]?.first);
  String num = FluroUtil.decode(params["num"]?.first);

  return EditIssuePage(
    title: title,
    body: body,
    url: url,
    num: num,
  );
});

var editCommentHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String body = FluroUtil.decode(params["body"]?.first);
  String url = FluroUtil.decode(params["url"]?.first);
  bool isAdd = FluroUtil.string2Bool(params["isAdd"]?.first);
  String id = FluroUtil.decode(params["id"]?.first);

  return EditCommentPage(body, url, isAdd, id);
});

var editReactionHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = FluroUtil.decode(params["url"]?.first);
  String content = FluroUtil.decode(params["content"]?.first);
  bool isIssue = FluroUtil.string2Bool(params["isIssue"]?.first);
  String id = FluroUtil.decode(params["id"]?.first);

  ReactionBloc bloc = ReactionBloc(url, content, isIssue, id);
  return BlocProvider<ReactionBloc>(
    child: ReactionPage(),
    bloc: bloc,
  );
});
