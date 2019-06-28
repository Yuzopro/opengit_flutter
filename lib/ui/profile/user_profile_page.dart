import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/ui/profile/user_follow_page.dart';
import 'package:open_git/ui/repos/repos_page.dart';
import 'package:open_git/ui/status/list_page_type.dart';

class UserProfilePage extends StatefulWidget {
  final UserBean userBean;

  UserProfilePage(this.userBean);

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState(userBean);
  }
}

class _UserProfileState extends State<UserProfilePage> {
  final UserBean userBean;

  String _userAvatar;

  _UserProfileState(this.userBean);

  List<Choice> _choices;

  @override
  void initState() {
    super.initState();

    _choices = <Choice>[
      Choice(title: '项目', widget: ReposPage(type: ListPageType.repos_user)),
      Choice(
          title: 'Star过的项目',
          widget: ReposPage(type: ListPageType.repos_user_star)),
      Choice(title: '关注我的', widget: FollowPage(ListPageType.by_follower)),
      Choice(title: '我关注的', widget: FollowPage(ListPageType.follower)),
//      Choice(title: '所在组织', widget: Text('所在组织')),
    ];

    if (userBean != null) {
      _userAvatar = userBean.avatarUrl ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _choices.length,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: new TabBarView(
          children: _choices.map((choice) {
            return choice.widget;
          }).toList(),
        ),
      )),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 200.0,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                _userAvatar,
                fit: BoxFit.cover,
              ),
              new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: new Container(
                  decoration:
                      new BoxDecoration(color: Colors.black.withOpacity(0.2)),
                ),
              )
            ],
          ),
        ),
        bottom: new TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: _choices.map((Choice choice) {
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
