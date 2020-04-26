import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:open_git/route/route_handlers.dart';

class AppRoutes {
  static final splash = '/';
  static final guide = '/guide';
  static final main = '/main';
  static final login = '/login';
  static final setting = '/main/setting';
  static final theme = '/main/setting/theme';
  static final language = '/main/setting/language';
  static final webview = '/main/webview';
  static final about = '/main/about';
  static final share = '/main/share';
  static final timeline = '/main/about/timeline';
  static final timeline_detail = '/main/about/timeline/detail';
  static final trend = '/main/trend';
  static final trend_date = '/main/trend/date';
  static final trend_language = '/main/trend/language';
  static final repo_detail = '/main/repos/detail';
  static final repo_event = '/main/repos/event';
  static final repo_trend = '/main/repos/trend';
  static final repo_file = '/main/repos/file';
  static final repo_code = '/main/repos/code';
  static final photo_view = '/main/photo/view';
  static final search = '/main/searct';
  static final reaction = '/main/issue/reaction';
  static final author = '/main/author';
  static final other = '/main/other';
  static final profile = '/main/profile';
  static final issue_detail = '/main/issue/detail';
  static final edit_issue = '/main/edit/issue';
  static final cache = '/main/setting/cache';
  static final profile_repos = '/main/profile/repos';
  static final profile_star_repos = '/main/profile/star_repos';
  static final profile_follower = '/main/profile/follower';
  static final profile_following = '/main/profile/following';
  static final profile_org = '/main/profile/org';
  static final profile_event = '/main/profile/event';
  static final org_profile = '/main/org';
  static final org_event = '/main/org/event';
  static final org_repos = '/main/org/repos';
  static final org_member = '/main/org/member';
  static final issue_label = '/main/issue/label';
  static final repo_contributor = '/main/repo/contributor';
  static final repo_stargazer = '/main/repo/stargazer';
  static final repo_subscriber = '/main/repo/subscriber';
  static final repo_issue = '/main/repo/issue';
  static final repo_fork = '/main/repo/fork';
  static final repo_topic = '/main/repo/topic';
  static final edit_profile = '/main/edit/profile';
  static final edit_issue_comment = '/main/edit/comment';
  static final edit_issue_reaction = '/main/edit/reaction';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ROUTE WAS NOT FOUND !!!');
    });
    router.define(
      splash,
      handler: splashHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      guide,
      handler: guideHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      main,
      handler: mainHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      login,
      handler: loginHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      setting,
      handler: settingHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      theme,
      handler: themeHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      language,
      handler: languageHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      webview,
      handler: webviewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      about,
      handler: aboutHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      share,
      handler: shareHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      timeline,
      handler: timelineHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      timeline_detail,
      handler: timelineDetailHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      trend,
      handler: trendHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_detail,
      handler: reposDetailHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_event,
      handler: reposEventHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_trend,
      handler: reposTrendHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_file,
      handler: reposFileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_code,
      handler: reposCodeHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      photo_view,
      handler: photoViewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      search,
      handler: searchHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      author,
      handler: authorHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      other,
      handler: otherHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile,
      handler: profileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      issue_detail,
      handler: issueDetailHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      cache,
      handler: cacheHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_repos,
      handler: profileReposHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_star_repos,
      handler: profileStarReposHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_follower,
      handler: profileFollowerHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_following,
      handler: profileFollowingHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_org,
      handler: profileOrgHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      profile_event,
      handler: profileEventHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      org_profile,
      handler: orgProfileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      org_event,
      handler: orgEventHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      org_repos,
      handler: orgReposHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      org_member,
      handler: orgMemberHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      issue_label,
      handler: issueLabelHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_contributor,
      handler: repoContributorHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_stargazer,
      handler: repoStargazerHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_subscriber,
      handler: repoSubscriberHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_issue,
      handler: repoIssueHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_fork,
      handler: repoForkHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      trend_date,
      handler: trendDateHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      trend_language,
      handler: trendLanguageHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      edit_profile,
      handler: editProfileHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      edit_issue,
      handler: editIssueHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      edit_issue_comment,
      handler: editCommentHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      edit_issue_reaction,
      handler: editReactionHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      repo_topic,
      handler: topicReposHandler,
      transitionType: TransitionType.cupertino,
    );
  }
}
