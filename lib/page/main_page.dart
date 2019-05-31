import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/page/drawer_page.dart';
import 'package:open_git/page/event_page.dart';
import 'package:open_git/page/home_page.dart';
import 'package:open_git/page/issue_page.dart';
import 'package:open_git/page/repository_page.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/route/navigator_util.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  UserBean _userBean;

  TabController _tabController;
  final PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    _userBean = LoginManager.instance.getUserBean();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    child: ImageUtil.getImageWidget(
                        _userBean.avatarUrl ?? "", 24.0),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              centerTitle: true,
              title: new TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: choices.map((Choice choice) {
                  return new Tab(
                    text: choice.title,
                  );
                }).toList(),
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
              ),
              actions: <Widget>[
                new IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    NavigatorUtil.goSearch(context);
                  },
                ),
              ],
            ),
            body: new PageView(
              controller: _pageController,
              children: <Widget>[
                HomePage(),
                RepositoryPage(LoginManager.instance.getUserBean(), false),
                EventPage(LoginManager.instance.getUserBean().login),
                IssuePage(LoginManager.instance.getUserBean().login),
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
