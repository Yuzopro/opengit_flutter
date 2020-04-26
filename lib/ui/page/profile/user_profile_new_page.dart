import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/org_bloc.dart';
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

class UserProfilePage extends StatefulWidget {
  final String name;
  final String avatar;
  final String heroTag;

  UserProfilePage({Key key, this.name, this.avatar, this.heroTag})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController _tabController;

  RepoUserBloc _repoUserBloc;
  RepoUserStarBloc _repoUserStarBloc;
  FollowersBloc _followersBloc;
  FollowingBloc _followingBloc;
  UserEventBloc _userEventBloc;
  OrgBloc _orgBloc;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 6);

    _repoUserBloc = RepoUserBloc(widget.name);
    _repoUserStarBloc = RepoUserStarBloc(widget.name);
    _followersBloc = FollowersBloc(widget.name);
    _followingBloc = FollowingBloc(widget.name);
    _userEventBloc = UserEventBloc(widget.name);
    _orgBloc = OrgBloc(widget.name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 6,
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
                        tag: widget.heroTag + widget.name,
                        child: ImageUtil.getNetworkImage(widget.avatar),
                        transitionOnUserGestures: true,
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
                          child: Text("star项目"),
                        ),
                        Tab(
                          child: Text("我关注的"),
                        ),
                        Tab(
                          child: Text("关注我的"),
                        ),
                        Tab(
                          child: Text("动态"),
                        ),
                        Tab(
                          child: Text("组织"),
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
                  child: RepoPage(RepoPage.PAGE_USER),
                  bloc: _repoUserBloc,
                ),
                BlocProvider<RepoBloc>(
                  child: RepoPage(RepoPage.PAGE_USER_STAR),
                  bloc: _repoUserStarBloc,
                ),
                BlocProvider<UserBloc>(
                  child: FollowingPage(),
                  bloc: _followingBloc,
                ),
                BlocProvider<UserBloc>(
                  child: FollowerPage(),
                  bloc: _followersBloc,
                ),
                BlocProvider<EventBloc>(
                  child: EventPage(false),
                  bloc: _userEventBloc,
                ),
                BlocProvider<OrgBloc>(
                  child: OrgPage(),
                  bloc: _orgBloc,
                )
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
