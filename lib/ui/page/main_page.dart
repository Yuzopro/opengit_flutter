import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/bloc/issue_bloc.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/bloc/repos_main_bloc.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/drawer_page.dart';
import 'package:open_git/ui/page/event_page.dart';
import 'package:open_git/ui/page/home_page.dart';
import 'package:open_git/ui/page/issue_page.dart';
import 'package:open_git/ui/page/repos_page.dart';
import 'package:open_git/util/image_util.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final String TAG = "MainPage";

  final PageController _pageController = PageController();

  TabController _tabController;

  UserBean _userBean;

  HomeBloc _homeBloc;
  ReposBloc _reposBloc;
  EventBloc _eventBloc;
  IssueBloc _issueBloc;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: 4);

    _userBean = LoginManager.instance.getUserBean();

    String userName = _userBean != null ? _userBean.login : "";

    _homeBloc = HomeBloc();
    _reposBloc = ReposMainBloc(userName);
    _eventBloc = EventBloc(userName);
    _issueBloc = IssueBloc(userName);
  }

  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = List(4);
    choices[0] = Choice(
      title: AppLocalizations.of(context).currentlocal.home,
    );
    choices[1] = Choice(
      title: AppLocalizations.of(context).currentlocal.repository,
    );
    choices[2] = Choice(
      title: AppLocalizations.of(context).currentlocal.event,
    );
    choices[3] = Choice(
      title: AppLocalizations.of(context).currentlocal.issue,
    );

    return WillPopScope(
        child: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            drawer: Drawer(
                child: DrawerPage(
              name: _userBean.login ?? "--",
              email: _userBean.email ?? "--",
              headUrl: _userBean.avatarUrl ?? "",
            )),
            appBar: AppBar(
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  tooltip: 'Open Drawer',
                  icon:
                      ImageUtil.getImageWidget(_userBean.avatarUrl ?? "", 24.0),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              centerTitle: true,
              title: TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.all(8.0),
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    text: choice.title,
                  );
                }).toList(),
                onTap: (index) {
                  _pageController
                      .jumpTo(MediaQuery.of(context).size.width * index);
                },
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    NavigatorUtil.goSearch(context);
                  },
                ),
              ],
            ),
            //慎用TabBarView，假如现在有四个tab，如果首次进入app之后，
            //点击issue tab，动态 tab也会触发加载数据，并且立即销毁
            body: PageView(
              controller: _pageController,
              children: <Widget>[
                BlocProvider<HomeBloc>(
                  child: HomePage(),
                  bloc: _homeBloc,
                ),
                BlocProvider<ReposBloc>(
                  child: ReposPage(ListPageType.repos),
                  bloc: _reposBloc,
                ),
                BlocProvider<EventBloc>(
                  child: EventPage(),
                  bloc: _eventBloc,
                ),
                BlocProvider<IssueBloc>(
                  child: IssuePage(),
                  bloc: _issueBloc,
                ),
              ],
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
            ),
          ),
        ),
        onWillPop: () {
          return _handleExitApp(context);
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _handleExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    CacheProvider provider = CacheProvider();
                    provider.delete();

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
