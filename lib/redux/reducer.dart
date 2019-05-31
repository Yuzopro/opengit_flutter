import 'package:open_git/redux/state.dart';
import 'package:open_git/redux/theme_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    themeData: themeReducer(state.themeData, action),
  );
}