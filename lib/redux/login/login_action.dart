import 'package:flutter/widgets.dart';
import 'package:open_git/bean/user_bean.dart';

class FetchLoginAction {
  final BuildContext context;
  final String userName;
  final String password;

  FetchLoginAction(this.context, this.userName, this.password);
}

class AuthLoginAction {
  final BuildContext context;
  final String code;

  AuthLoginAction(this.context, this.code);
}

class ReceivedLoginAction {
  ReceivedLoginAction(
    this.token,
    this.userBean,
  );

  final String token;
  final UserBean userBean;
}

class RequestingLoginAction {}

class ErrorLoadingLoginAction {}
