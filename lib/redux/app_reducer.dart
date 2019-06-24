import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/event/event_reducer.dart';
import 'package:open_git/redux/home/home_reducer.dart';
import 'package:open_git/redux/issue/issue_reducer.dart';
import 'package:open_git/redux/locale_reducer.dart';
import 'package:open_git/redux/repos/repos_reducer.dart';
import 'package:open_git/redux/theme_reducer.dart';
import 'package:open_git/redux/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    themeData: themeReducer(state.themeData, action),
    locale: localeReducer(state.locale, action),
    userState: userReducer(state.userState, action),
    homeState: homeReducer(state.homeState, action),
    reposState: reposReducer(state.reposState, action),
    eventState: eventReducer(state.eventState, action),
    issueState: issueReducer(state.issueState, action),
  );
}
