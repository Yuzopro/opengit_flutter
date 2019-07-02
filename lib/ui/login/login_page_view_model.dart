import 'package:flutter/widgets.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

typedef OnLogin = void Function(String name, String password);

class LoginPageViewModel {
  static final String TAG = "LoginPageViewModel";

  final OnLogin onLogin;
  final LoadingStatus status;

  LoginPageViewModel({this.onLogin, this.status});

  static LoginPageViewModel fromStore(
      Store<AppState> store, BuildContext context) {
    return LoginPageViewModel(
      status: store.state.loginState.status,
      onLogin: (String name, String password) {
        LogUtil.v('name is $name, password is $password', tag: TAG);
        store.dispatch(FetchLoginAction(context, name, password));
      },
    );
  }
}
