import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/redux/login/login_state.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "loginReducer";

final loginReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, RequestingLoginAction>(_requestingLogin),
  TypedReducer<LoginState, ReceivedLoginAction>(_receivedLogin),
  TypedReducer<LoginState, ErrorLoadingLoginAction>(_errorLoadingLogin),
]);

LoginState _requestingLogin(LoginState state, action) {
  LogUtil.v('_requestingLogin', tag: TAG);
  return state.copyWith(status: LoadingStatus.loading);
}

LoginState _receivedLogin(LoginState state, action) {
  LogUtil.v('_receivedLogin', tag: TAG);
  return state.copyWith(status: LoadingStatus.success, token: action.token);
}

LoginState _errorLoadingLogin(LoginState state, action) {
  LogUtil.v('_errorLoadingLogin', tag: TAG);
  return state.copyWith(status: LoadingStatus.error);
}
