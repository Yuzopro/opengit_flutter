import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/user/user_state.dart';
import 'package:open_git/status/status.dart';
import 'package:redux/redux.dart';


final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, InitCompleteAction>(_refresh),
]);

UserState _refresh(UserState state, action) {
  LoginStatus status = LoginStatus.error;
  if (action.userBean != null) {
    status = LoginStatus.success;
  }
  return state.copyWith(
    status: status,
    currentUser: action.userBean,
    token: action.token,
  );
}
