import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/page/drawer_page.dart';
import 'package:open_git/page/dynamic_page.dart';
import 'package:open_git/page/home_page.dart';
import 'package:open_git/page/issue_page.dart';
import 'package:open_git/page/project_page.dart';
import 'package:open_git/page/search_page.dart';

class MainPage extends StatefulWidget {
  static const String sName = "main_page";

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final GitSearchDelegate _delegate = new GitSearchDelegate();

  UserBean _userBean;

  @override
  void initState() {
    super.initState();
    _userBean = LoginManager.instance.getUserBean();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new DefaultTabController(
          length: choices.length,
          child: new Scaffold(
            drawer: new Drawer(
                child: new DrawerPage(
              name: _userBean.login ?? "--",
              email: _userBean.blog ?? "--",
              headUrl: _userBean.avatarUrl ?? "",
            )),
            appBar: new AppBar(
              leading: Builder(builder: (BuildContext context) {
                return new IconButton(
                  tooltip: 'Open Drawer',
                  icon: new ClipOval(
                    child: new FadeInImage.assetNetwork(
                      placeholder: "image/ic_welcome.png",
                      //预览图
                      fit: BoxFit.fitWidth,
                      image: _userBean.avatarUrl ?? "",
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              centerTitle: true,
              title: new TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: choices.map((Choice choice) {
                  return new Tab(
                    text: choice.title,
                  );
                }).toList(),
              ),
              actions: <Widget>[
                new IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await showSearch<int>(
                      context: context,
                      delegate: _delegate,
                    );
                  },
                ),
              ],
            ),
            body: new TabBarView(
              children: <Widget>[
                HomePage(),
                ProjectPage(),
                DynamicPage(),
                IssuePage(),
              ],
            ),
          ),
        ),
        onWillPop: () {
          return _handleExitApp(context);
        });
  }

  Future<bool> _handleExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text("提示"),
              content: Text("确定要退出应用？"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "取消",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "确定",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ));
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '主页'),
  const Choice(title: '项目'),
  const Choice(title: '动态'),
  const Choice(title: '问题'),
];
