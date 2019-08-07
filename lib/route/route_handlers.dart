import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/contributor_bloc.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/stargazer_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/bloc/label_bloc.dart';
import 'package:open_git/bloc/org_bloc.dart';
import 'package:open_git/bloc/org_event_bloc.dart';
import 'package:open_git/bloc/org_member_bloc.dart';
import 'package:open_git/bloc/org_profile_bloc.dart';
import 'package:open_git/bloc/org_repos_bloc.dart';
import 'package:open_git/bloc/profile_bloc.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/bloc/repos_detail_bloc.dart';
import 'package:open_git/bloc/repos_event_bloc.dart';
import 'package:open_git/bloc/repos_file_bloc.dart';
import 'package:open_git/bloc/repos_trend_bloc.dart';
import 'package:open_git/bloc/repos_user_bloc.dart';
import 'package:open_git/bloc/repos_user_star_bloc.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/bloc/user_event_bloc.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/fluro_convert_util.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/other/about_page.dart';
import 'package:open_git/ui/page/other/author_page.dart';
import 'package:open_git/ui/page/other/cache_page.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/guide/guide_page.dart';
import 'package:open_git/ui/page/issue/label_page.dart';
import 'package:open_git/ui/page/issue/issue_detail_page.dart';
import 'package:open_git/ui/page/other/language_page.dart';
import 'package:open_git/ui/page/login/login_page.dart';
import 'package:open_git/ui/page/home/main_page.dart';
import 'package:open_git/ui/page/other/other_page.dart';
import 'package:open_git/ui/page/profile/org_profile_page.dart';
import 'package:open_git/ui/page/profile/user_page.dart';
import 'package:open_git/ui/page/profile/user_org_page.dart';
import 'package:open_git/ui/page/profile/user_profile_page.dart';
import 'package:open_git/ui/page/repo/repo_code_detail_page.dart';
import 'package:open_git/ui/page/repo/repo_detail_page.dart';
import 'package:open_git/ui/page/repo/repo_event_page.dart';
import 'package:open_git/ui/page/repo/repo_file_page.dart';
import 'package:open_git/ui/page/home/repos_page.dart';
import 'package:open_git/ui/page/repo/repo_trend_page.dart';
import 'package:open_git/ui/page/home/search_page.dart';
import 'package:open_git/ui/page/other/setting_page.dart';
import 'package:open_git/ui/page/other/share_page.dart';
import 'package:open_git/ui/page/guide/splash_page.dart';
import 'package:open_git/ui/page/other/theme_page.dart';
import 'package:open_git/ui/page/other/timeline_detail_page.dart';
import 'package:open_git/ui/page/other/timeline_page.dart';
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
  String title = params["title"]?.first;
  String url = params["url"]?.first;
  String isAd = params["isAd"]?.first;

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
  String title = params["title"]?.first;
  String body = params["body"]?.first;
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
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;
  return BlocProvider<ReposDetailBloc>(
    child: RepoDetailPage(),
    bloc: ReposDetailBloc(reposOwner, reposName),
  );
});

var reposEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposEventBloc>(
    child: RepoEventPage(),
    bloc: ReposEventBloc(reposOwner, reposName),
  );
});

var reposTrendHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String language = params["language"]?.first;

  return BlocProvider<ReposTrendBloc>(
    child: RepoTrendPage(),
    bloc: ReposTrendBloc(language),
  );
});

var reposFileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reposOwner = params["reposOwner"]?.first;
  String reposName = params["reposName"]?.first;

  return BlocProvider<ReposFileBloc>(
    child: RepoFilePage(),
    bloc: ReposFileBloc(reposOwner, reposName),
  );
});

var reposCodeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return CodeDetailPageWeb(
    title: title,
    htmlUrl: url,
  );
});

var photoViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params["title"]?.first;
  String url = params["url"]?.first;

  return PhotoViewPage(title, url);
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
  String name = params["name"]?.first;

  return BlocProvider<ProfileBloc>(
    child: UserProfilePage(),
    bloc: ProfileBloc(name),
  );
});

var issueDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  IssueDetailBloc bloc = IssueDetailBloc(
      IssueBean.fromJson(FluroConvertUtil.string2Map(params["issue"]?.first)));
  return BlocProvider<IssueDetailBloc>(
    child: IssueDetailPage(),
    bloc: bloc,
  );
});

var cacheHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CachePage();
});

var profileReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<ReposBloc>(
    child: ReposPage(PageType.repos_user),
    bloc: ReposUserBloc(name),
  );
});

var profileStarReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<ReposBloc>(
    child: ReposPage(PageType.repos_user_star),
    bloc: ReposUserStarBloc(name),
  );
});

var profileFollowerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<UserBloc>(
    child: UserPage(PageType.followers),
    bloc: FollowersBloc(name),
  );
});

var profileFollowingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<UserBloc>(
    child: UserPage(PageType.following),
    bloc: FollowingBloc(name),
  );
});

var profileOrgHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<OrgBloc>(
    child: OrgPage(),
    bloc: OrgBloc(name),
  );
});

var profileEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<EventBloc>(
    child: EventPage(PageType.user_event),
    bloc: UserEventBloc(name),
  );
});

var orgProfileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<OrgProfileBloc>(
    child: OrgProfilePage(),
    bloc: OrgProfileBloc(name),
  );
});

var orgEventHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<EventBloc>(
    child: EventPage(PageType.org_event),
    bloc: OrgEventBloc(name),
  );
});

var orgReposHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<ReposBloc>(
    child: ReposPage(PageType.org_repos),
    bloc: ReposOrgBloc(name),
  );
});

var orgMemberHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String name = params["name"]?.first;

  return BlocProvider<UserBloc>(
    child: UserPage(PageType.org_member),
    bloc: OrgMemberBloc(name),
  );
});

var issueLabelHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//  String name = params["name"]?.first;
//  String repo = FluroConvertUtil.fluroCnParamsDecode(params["repo"]?.first);
//
//  LogUtil.v('333 $repo');
//
//  return BlocProvider<LabelBloc>(
//    child: LabelPage(),
//    bloc: LabelBloc(name, repo),
//  );
});

var repoContributorHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = params["url"]?.first;

  return BlocProvider<UserBloc>(
    child: UserPage(PageType.repo_contributors),
    bloc: ContributorBloc(url),
  );
});

var repoStargazerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = params["url"]?.first;

  return BlocProvider<UserBloc>(
    child: UserPage(PageType.repo_stargazers),
    bloc: StargazerBloc(url),
  );
});
