import 'package:flutter/material.dart';
import 'package:open_git/redux/event/event_state.dart';
import 'package:open_git/redux/home/home_state.dart';
import 'package:open_git/redux/issue/issue_state.dart';
import 'package:open_git/redux/repos/repos_state.dart';
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

  //用户信息
  final UserState userState;

  //系统语言
  Locale platformLocale;

  AppState(
      {this.themeData,
      this.locale,
      this.userState,
      this.homeState,
      this.reposState,
      this.eventState,
      this.issueState});

  factory AppState.initial() => AppState(
      themeData: AppTheme.theme,
      locale: Locale('zh', 'CH'),
      userState: UserState.initial(),
      homeState: HomeState.initial(),
      reposState: ReposState.initial(),
      eventState: EventState.initial(),
      issueState: IssueState.initial());
}
