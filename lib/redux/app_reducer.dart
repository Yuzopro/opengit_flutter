import 'package:open_git/redux/about/about_reducer.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/locale_reducer.dart';
import 'package:open_git/redux/login/login_reducer.dart';
import 'package:open_git/redux/theme_reducer.dart';
import 'package:open_git/redux/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    themeData: themeReducer(state.themeData, action),
    locale: localeReducer(state.locale, action),
    loginState: loginReducer(state.loginState, action),
    userState: userReducer(state.userState, action),
    aboutState: aboutReducer(state.aboutState, action),
  );
}
