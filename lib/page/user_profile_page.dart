import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/page/repository_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfilePage> {
  String _userName;
  String _userAvatar;

  @override
  void initState() {
    super.initState();
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null) {
      print(userBean.toString());
      _userName = userBean.login ?? "";
      _userAvatar = userBean.avatarUrl ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: choices.length,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: new TabBarView(
            children: choices.map((choice) {
          return choice.widget;
        }).toList()),
      )),
    );
  }

  Future<Null> onRefresh() {}

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,
        expandedHeight: 200.0,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
//          title: new Text(_userName),
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                _userAvatar,
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, -0.4),
                    colors: <Color>[Color(0x60000000), Color(0x00000000)],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: new TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: choices.map((Choice choice) {
            return new Tab(
              text: choice.title,
            );
          }).toList(),
        ),
      ),
    ];
  }
}

class Choice {
  Choice({this.title, this.widget});

  final String title;
  final Widget widget;
}

List<Choice> choices = <Choice>[
  Choice(title: '项目', widget: RepositoryPage(false)),
  Choice(title: 'Star过的项目', widget: RepositoryPage(true)),
  Choice(title: '关注我的', widget: RepositoryPage(false)),
  Choice(title: '我关注的', widget: RepositoryPage(false)),
  Choice(title: '所在组织', widget: RepositoryPage(false)),
];
