import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/bloc/issue_bloc.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/page/drawer_page.dart';
import 'package:open_git/page/event_page.dart';
import 'package:open_git/page/home_page.dart';
import 'package:open_git/page/issue_page.dart';
import 'package:open_git/page/repos_page.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';

class MainPage extends StatelessWidget {
  static final String TAG = "MainPage";

  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = new List(4);
    choices[0] =
        new Choice(title: AppLocalizations.of(context).currentlocal.home);
    choices[1] =
        new Choice(title: AppLocalizations.of(context).currentlocal.repository);
    choices[2] =
        new Choice(title: AppLocalizations.of(context).currentlocal.event);
    choices[3] =
        new Choice(title: AppLocalizations.of(context).currentlocal.issue);

    UserBean _userBean = LoginManager.instance.getUserBean();

    String userName = _userBean != null ? _userBean.login : "";

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
                labelPadding: EdgeInsets.all(8.0),
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
                  onPressed: () {
                    NavigatorUtil.goSearch(context);
                  },
                ),
              ],
            ),
            body: new TabBarView(
              children: <Widget>[
                new BlocProvider<HomeBloc>(
                  child: HomePage(),
                  bloc: new HomeBloc(),
                ),
                new BlocProvider<ReposBloc>(
                  child: ReposPage(LoginManager.instance.getUserBean(), false),
                  bloc: new ReposBloc(
                      LoginManager.instance.getUserBean().login, false),
                ),
                new BlocProvider<EventBloc>(
                  child: EventPage(userName),
                  bloc: new EventBloc(userName),
                ),
                new BlocProvider<IssueBloc>(
                  child: IssuePage(userName),
                  bloc: new IssueBloc(userName),
                ),
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
              title: Text(
                  AppLocalizations.of(context).currentlocal.dialog_exit_title),
              content: Text(AppLocalizations.of(context)
                  .currentlocal
                  .dialog_exit_content),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).currentlocal.cancel,
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).currentlocal.ok,
                    style: TextStyle(color: Colors.black),
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
