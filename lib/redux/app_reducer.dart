import 'package:open_git/redux/about/about_reducer.dart';
import 'package:open_git/redux/about/timeline_reducer.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/event/event_reducer.dart';
import 'package:open_git/redux/home/home_reducer.dart';
import 'package:open_git/redux/issue/issue_reducer.dart';
import 'package:open_git/redux/locale_reducer.dart';
import 'package:open_git/redux/login/login_reducer.dart';
import 'package:open_git/redux/profile/follow_reducer.dart';
import 'package:open_git/redux/repos/repos_detail_reducer.dart';
import 'package:open_git/redux/repos/repos_reducer.dart';
import 'package:open_git/redux/repos/repos_source_code_reducer.dart';
import 'package:open_git/redux/repos/repos_source_file_reducer.dart';
import 'package:open_git/redux/search/search_reducer.dart';
import 'package:open_git/redux/theme_reducer.dart';
import 'package:open_git/redux/trend/trend_reducer.dart';
import 'package:open_git/redux/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      themeData: themeReducer(state.themeData, action),
      locale: localeReducer(state.locale, action),
      loginState: loginReducer(state.loginState, action),
      userState: userReducer(state.userState, action),
      homeState: homeReducer(state.homeState, action),
      reposState: reposReducer(state.reposState, action),
      eventState: eventReducer(state.eventState, action),
      issueState: issueReducer(state.issueState, action),
      trendState: trendReducer(state.trendState, action),
      aboutState: aboutReducer(state.aboutState, action),
      timelineState: timelineReducer(state.timelineState, action),
      followState: followReducer(state.followState, action),
      reposDetailState: reposDetailReducer(state.reposDetailState, action),
      reposSourceFileState:
          reposSourceFileReducer(state.reposSourceFileState, action),
      reposSourceCodeState:
          reposSourceCodeReducer(state.reposSourceCodeState, action),
      searchState: searchReducer(state.searchState, action));
}
