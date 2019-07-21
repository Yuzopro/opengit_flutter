import 'dart:ui';

import 'package:flutter/material.dart';
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
  final String name;
  final String avatar;

  const UserProfilePage(this.name, this.avatar);

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
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
          bloc: ReposUserBloc(widget.name),
        ),
      ),
      Choice(
        title: 'Star过的项目',
        widget: BlocProvider<ReposBloc>(
          child: ReposPage(ListPageType.repos_user_star),
          bloc: ReposUserStarBloc(widget.name),
        ),
      ),
      Choice(
        title: '关注我的',
        widget: BlocProvider<FollowBloc>(
          child: FollowPage(ListPageType.followers),
          bloc: FollowersBloc(widget.name),
        ),
      ),
      Choice(
        title: '我关注的',
        widget: BlocProvider<FollowBloc>(
          child: FollowPage(ListPageType.following),
          bloc: FollowingBloc(widget.name),
        ),
      ),
//      Choice(title: '所在组织', widget: Text('所在组织')),
    ];

    _tabController = TabController(vsync: this, length: _choices.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _choices.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: PageView(
            controller: _pageController,
            children: _choices.map((choice) {
              return choice.widget;
            }).toList(),
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
          ),
        ),
      ),
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
                widget.avatar,
                fit: BoxFit.cover,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              )
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: _choices.map((Choice choice) {
            return Tab(
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
