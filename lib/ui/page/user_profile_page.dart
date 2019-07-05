import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/bloc/repos_user_bloc.dart';
import 'package:open_git/bloc/repos_user_star_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/repos_page.dart';
import 'package:open_git/ui/page/user_follow_page.dart';

class UserProfilePage extends StatefulWidget {
  final UserBean userBean;

  UserProfilePage(this.userBean);

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  String _userAvatar;

  _UserProfileState();

  List<Choice> _choices;

  final PageController _pageController = PageController();

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _choices = <Choice>[
      Choice(
        title: '项目',
        widget: BlocProvider<ReposBloc>(
          child: ReposPage(ListPageType.repos_user),
          bloc: new ReposUserBloc(widget.userBean.login),
        ),
      ),
      Choice(
        title: 'Star过的项目',
        widget: BlocProvider<ReposBloc>(
          child: ReposPage(ListPageType.repos_user_star),
          bloc: new ReposUserStarBloc(widget.userBean.login),
        ),
      ),
      Choice(
        title: '关注我的',
        widget: BlocProvider<FollowBloc>(
          child: FollowPage(ListPageType.followers),
          bloc: FollowersBloc(widget.userBean.login),
        ),
      ),
      Choice(
        title: '我关注的',
        widget: BlocProvider<FollowBloc>(
          child: FollowPage(ListPageType.following),
          bloc: FollowingBloc(widget.userBean.login),
        ),
      ),
//      Choice(title: '所在组织', widget: Text('所在组织')),
    ];

    if (widget.userBean != null) {
      _userAvatar = widget.userBean.avatarUrl ?? "";
    }

    _tabController = new TabController(vsync: this, length: _choices.length);
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _choices.length,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: new PageView(
          controller: _pageController,
          children: _choices.map((choice) {
            return choice.widget;
          }).toList(),
          onPageChanged: (index) {
            _tabController.animateTo(index);
          },
        ),
      )),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onTap: (index) {
            _pageController.jumpTo(MediaQuery.of(context).size.width * index);
          },
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
