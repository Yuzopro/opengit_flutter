import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/org_event_bloc.dart';
import 'package:open_git/bloc/org_member_bloc.dart';
import 'package:open_git/bloc/org_repo_bloc.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/home/repo_page.dart';

import 'org_member_page.dart';

class OrgProfilePage extends StatefulWidget {
  final String name;
  final String avatar;

  OrgProfilePage({Key key, this.name, this.avatar}) : super(key: key);

  @override
  _OrgProfileState createState() => _OrgProfileState();
}

class _OrgProfileState extends State<OrgProfilePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController _tabController;

  RepoOrgBloc _repoOrgBloc;
  OrgEventBloc _orgEventBloc;
  OrgMemberBloc _orgMemberBloc;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);

    _repoOrgBloc = RepoOrgBloc(widget.name);
    _orgEventBloc = OrgEventBloc(widget.name);
    _orgMemberBloc = OrgMemberBloc(widget.name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (c, s) => [
            SliverAppBar(
              expandedHeight: 206.0,
              pinned: true,
              title: _buildTitle(),
              flexibleSpace: _buildFlexibleSpace(),
              bottom: _buildTabBar(),
            )
          ],
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.name,
      style: YZStyle.normalTextWhite,
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: Hero(
        tag: "hero_org_image_${widget.name}",
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ImageUtil.getNetworkImage(widget.avatar),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: new Container(
                color: Colors.black.withOpacity(0.1),
                width: ScreenUtil.getScreenWidth(context),
                height: 206,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      indicatorColor: Colors.white,
      tabs: <Widget>[
        _buildTabItem("项目"),
        _buildTabItem("动态"),
        _buildTabItem("成员"),
      ],
      onTap: (index) {
        _pageController.jumpTo(ScreenUtil.getScreenWidth(context) * index);
      },
    );
  }

  Widget _buildTabItem(String tab) {
    return Tab(
      child: Text(tab),
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        BlocProvider<RepoBloc>(
          child: RepoPage(RepoPage.PAGE_ORG),
          bloc: _repoOrgBloc,
        ),
        BlocProvider<EventBloc>(
          child: EventPage(false),
          bloc: _orgEventBloc,
        ),
        BlocProvider<UserBloc>(
          child: OrgMemberPage(),
          bloc: _orgMemberBloc,
        ),
      ],
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
