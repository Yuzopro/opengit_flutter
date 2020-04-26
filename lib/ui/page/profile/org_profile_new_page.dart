import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/org_bloc.dart';
import 'package:open_git/bloc/org_event_bloc.dart';
import 'package:open_git/bloc/org_member_bloc.dart';
import 'package:open_git/bloc/org_repo_bloc.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/bloc/repo_user_bloc.dart';
import 'package:open_git/bloc/repo_user_star_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/bloc/user_event_bloc.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/home/repo_page.dart';
import 'package:open_git/ui/page/profile/follower_page.dart';
import 'package:open_git/ui/page/profile/following_page.dart';
import 'package:open_git/ui/page/profile/user_org_page.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';

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
                    title: Text(
                      widget.name,
                      style: YZStyle.normalTextWhite,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Hero(
                        tag: "hero_org_image_${widget.name}",
                        child: ImageUtil.getNetworkImage(widget.avatar),
                      ),
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      tabs: <Widget>[
                        Tab(
                          child: Text("项目"),
                        ),
                        Tab(
                          child: Text("动态"),
                        ),
                        Tab(
                          child: Text("成员"),
                        ),
                      ],
                      onTap: (index) {
                        _pageController
                            .jumpTo(ScreenUtil.getScreenWidth(context) * index);
                      },
                    ),
                  ),
                ],
            body: PageView(
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
            )),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
