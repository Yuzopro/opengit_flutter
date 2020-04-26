import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/bloc/issue_bloc.dart';
import 'package:open_git/bloc/received_event_bloc.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/bloc/repo_main_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/red_point_manager.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/page/home/drawer_page.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/home/home_page.dart';
import 'package:open_git/ui/page/home/issue_page.dart';
import 'package:open_git/ui/page/home/repo_page.dart';
import 'package:open_git/util/common_util.dart';
import 'package:open_git/util/size_util.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final String TAG = "MainPage";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController();

  TabController _tabController;

  UserBean _userBean;

  HomeBloc _homeBloc;
  RepoBloc _reposBloc;
  EventBloc _eventBloc;
  IssueBloc _issueBloc;

  int _exitTime = 0;

  @override
  void initState() {
    super.initState();

    RedPointManager.instance.addState(this);

    _tabController = new TabController(vsync: this, length: 4);

    _userBean = LoginManager.instance.getUserBean();

    String userName = _userBean != null ? _userBean.login : "";

    _homeBloc = HomeBloc();
    _reposBloc = RepoMainBloc(userName);
    _eventBloc = ReceivedEventBloc(userName);
    _issueBloc = IssueBloc();
  }

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

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
            key: _scaffoldKey,
            drawer: Drawer(
              child: DrawerPage(),
            ),
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Open Drawer',
                        icon: ImageUtil.getCircleNetworkImage(
                            _userBean.avatar_url ?? "",
                            36.0,
                            ImagePath.image_default_head),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      Offstage(
                        offstage: !RedPointManager.instance.isUpgrade,
                        child: Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 5.0, right: 10.0),
                          child: CommonUtil.getRedPoint(),
                        ),
                      ),
                    ],
                  );
                },
              ),
              centerTitle: true,
              title: TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.all(8.0),
                indicatorColor: Colors.white,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    text: choice.title,
                  );
                }).toList(),
                onTap: (index) {
                  _pageController
                      .jumpTo(ScreenUtil.getScreenWidth(context) * index);
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
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                BlocProvider<HomeBloc>(
                  child: HomePage(),
                  bloc: _homeBloc,
                ),
                BlocProvider<RepoBloc>(
                  child: RepoPage(RepoPage.PAGE_HOME),
                  bloc: _reposBloc,
                ),
                BlocProvider<EventBloc>(
                  child: EventPage(false),
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
          return _exitApp();
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    RedPointManager.instance.removeState(this);
    RedPointManager.instance.dispose();
    super.dispose();
  }

  Future<bool> _exitApp() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else if ((DateTime.now().millisecondsSinceEpoch - _exitTime) > 2000) {
      ToastUtil.showMessgae('再按一次离开App');
      _exitTime = DateTime.now().millisecondsSinceEpoch;
      return Future.value(false);
    } else {
      await pop();
      return Future.value(true);
    }
  }

  Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}
