import 'package:flutter/material.dart';
import 'package:open_git/page/login_page.dart';
import 'package:open_git/page/main_page.dart';

class NavigatorUtil {
  //主页
  static goMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, MainPage.sName);
  }

  //登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }
}
