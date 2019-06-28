import 'package:flutter/material.dart';
import 'package:open_git/redux/about/about_state.dart';
import 'package:open_git/redux/about/timeline_state.dart';
import 'package:open_git/redux/event/event_state.dart';
import 'package:open_git/redux/home/home_state.dart';
import 'package:open_git/redux/issue/issue_state.dart';
import 'package:open_git/redux/profile/follow_state.dart';
import 'package:open_git/redux/repos/repos_detail_state.dart';
import 'package:open_git/redux/repos/repos_source_code_state.dart';
import 'package:open_git/redux/repos/repos_source_file_state.dart';
import 'package:open_git/redux/repos/repos_state.dart';
import 'package:open_git/redux/trend/trend_state.dart';
import 'package:open_git/redux/user/user_state.dart';
import 'package:open_git/util/theme_util.dart';

class AppState {
  //主题
  final ThemeData themeData;

  //语言
  final Locale locale;

  //主页
  final HomeState homeState;

  //项目
  final ReposState reposState;

  //动态
  final EventState eventState;

  //问题
  final IssueState issueState;

  //趋势
  final TrendState trendState;

  //关于
  final AboutState aboutState;

  //功能介绍
  final TimelineState timelineState;

  //关注
  final FollowState followState;

  //用户信息
  final UserState userState;

  //项目详情
  final ReposDetailState reposDetailState;

  //源码文件
  final ReposSourceFileState reposSourceFileState;

  //源码
  final ReposSourceCodeState reposSourceCodeState;

  //系统语言
  Locale platformLocale;

  AppState(
      {this.themeData,
      this.locale,
      this.userState,
      this.homeState,
      this.reposState,
      this.eventState,
      this.issueState,
      this.trendState,
      this.aboutState,
      this.timelineState,
      this.followState,
      this.reposDetailState,
      this.reposSourceFileState,
      this.reposSourceCodeState});

  factory AppState.initial() => AppState(
      themeData: AppTheme.theme,
      locale: Locale('zh', 'CH'),
      userState: UserState.initial(),
      homeState: HomeState.initial(),
      reposState: ReposState.initial(),
      eventState: EventState.initial(),
      issueState: IssueState.initial(),
      trendState: TrendState.initial(),
      aboutState: AboutState.initial(),
      timelineState: TimelineState.initial(),
      followState: FollowState.initial(),
      reposDetailState: ReposDetailState.initial(),
      reposSourceFileState: ReposSourceFileState.initial(),
      reposSourceCodeState: ReposSourceCodeState.initial());
}
