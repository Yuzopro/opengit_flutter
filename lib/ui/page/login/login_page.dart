import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/login/sign_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginPageViewModel>(
      distinct: true,
      converter: (store) => LoginPageViewModel.fromStore(store, context),
      builder: (_, viewModel) => SignPage(viewModel),
    );
  }
}

typedef OnLogin = void Function(String name, String password);
typedef OnAuth = void Function();

class LoginPageViewModel {
  static final String TAG = "LoginPageViewModel";

  final OnLogin onLogin;
  final OnAuth onAuth;
  final LoadingStatus status;

  LoginPageViewModel({this.onLogin, this.status, this.onAuth});

  static LoginPageViewModel fromStore(
      Store<AppState> store, BuildContext context) {
    return LoginPageViewModel(
        status: store.state.loginState.status,
        onLogin: (String name, String password) {
          ToastUtil.showMessgae('此功能暂不支持');
          // store.dispatch(FetchLoginAction(context, name, password));
        },
        onAuth: () async {
          String code =
              await NavigatorUtil.goLoginWebview(context, getOAuthUrl());
          LogUtil.v("login webview code $code");
          store.dispatch(AuthLoginAction(context, code));
        });
  }

  static getOAuthUrl() {
    return "https://github.com/login/oauth/authorize?client_id"
        "=${Config.CLIENT_ID}&state=app&"
        "redirect_uri=opengitapp://authed";
  }
}
