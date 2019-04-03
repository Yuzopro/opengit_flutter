import 'package:flutter/material.dart';
import 'package:open_git/page/login_page.dart';
import 'package:open_git/page/main_page.dart';
import 'package:open_git/page/splash_page.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      LoginPage.sName: (context) {
        return new LoginPage();
      },
      MainPage.sName: (context) {
        return new MainPage();
      }
    },
    theme: ThemeData(primaryColor: Colors.black),
    home: new SplashPage(),
  ));
}