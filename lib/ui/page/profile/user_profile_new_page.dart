import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/bloc/followers_bloc.dart';
import 'package:open_git/bloc/following_bloc.dart';
import 'package:open_git/bloc/org_bloc.dart';
import 'package:open_git/bloc/profile_bloc.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/bloc/repo_user_bloc.dart';
import 'package:open_git/bloc/repo_user_star_bloc.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/bloc/user_event_bloc.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/page/home/event_page.dart';
import 'package:open_git/ui/page/home/repo_page.dart';
import 'package:open_git/ui/page/profile/follower_page.dart';
import 'package:open_git/ui/page/profile/following_page.dart';
import 'package:open_git/ui/page/profile/user_org_page.dart';

class UserProfilePage
    extends BaseStatelessWidget<LoadingBean<UserBean>, ProfileBloc> {
  final String heroTag;

  UserProfilePage(this.heroTag);

  @override
  bool isShowAppBar(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    if (bloc.bean == null || bloc.bean.data == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String getTitle(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return bloc.name;
  }

  @override
  bool isShowAppBarActions() => false;

  @override
  int getItemCount(LoadingBean<UserBean> data) => 1;

  @override
  bool isLoading(LoadingBean<UserBean> data) =>
      data != null ? data.isLoading : true;

  @override
  void openWebView(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    NavigatorUtil.goWebView(context, bloc.name, bloc.bean.data.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return bloc.bean.data.htmlUrl;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<UserBean> bean) {
    if (bean == null || bean.data == null) {
      return Container();
    }
    return _UserProfilePage(userBean: bean.data, heroTag: heroTag);
  }
}

class _UserProfilePage extends StatefulWidget {
  final UserBean userBean;
  final String heroTag;

  _UserProfilePage({Key key, this.userBean, this.heroTag}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfilePage>
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

    var name = widget.userBean.login;
    _repoUserBloc = RepoUserBloc(name);
    _repoUserStarBloc = RepoUserStarBloc(name);
    _followersBloc = FollowersBloc(name);
    _followingBloc = FollowingBloc(name);
    _userEventBloc = UserEventBloc(name);
    _orgBloc = OrgBloc(name);

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
              title: _buildTitle(),
              actions: _getAction(context),
              flexibleSpace: _buildFlexibleSpace(),
              bottom: _buildTabBar(),
            ),
          ],
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.userBean.login,
      style: YZStyle.normalTextWhite,
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: Hero(
        tag: widget.heroTag + widget.userBean.login,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ImageUtil.getNetworkImage(widget.userBean.avatarUrl),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: new Container(
                color: Colors.black.withOpacity(0.1),
                width: ScreenUtil.getScreenWidth(context),
                height: 206,
              ),
            ),
          ],
        ),
        transitionOnUserGestures: true,
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      indicatorColor: Colors.white,
      tabs: <Widget>[
        _buildTabItem('项目', widget.userBean.publicRepos),
        _buildTabItem("star项目", -1),
        _buildTabItem("我关注的", widget.userBean.following),
        _buildTabItem("关注我的", widget.userBean.followers),
        _buildTabItem("动态", -1),
        _buildTabItem("组织", -1),
      ],
      onTap: (index) {
        _pageController.jumpTo(ScreenUtil.getScreenWidth(context) * index);
      },
    );
  }

  Widget _buildTabItem(String title, int count) {
    if (count == -1) {
      return Tab(
        child: Text(title),
      );
    } else {
      return Tab(
        child: Row(
          children: <Widget>[
            Text(title),
            SizedBox(
              width: 3.0,
            ),
            ClipOval(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                width: 14.0,
                height: 14.0,
                child: Text(
                  count.toString(),
                  style: YZStyle.minText,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBody() {
    return PageView(
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
    );
  }

  List<Widget> _getAction(BuildContext context) {
    var menus = <PopupMenuItem<String>>[];
    menus.add(_getPopupMenuItem('browser', Icons.language, '浏览器打开'));
    menus.add(_getPopupMenuItem('share', Icons.share, '分享'));
    if (widget.userBean.isFollow != null &&
        !UserManager.instance.isYou(widget.userBean.login)) {
      menus.add(_getPopupMenuItem(
          'follow',
          widget.userBean.isFollow ? Icons.delete : Icons.add,
          widget.userBean.isFollow ? '取消关注' : '关注'));
    }

    return [
      PopupMenuButton(
        padding: const EdgeInsets.all(0.0),
        onSelected: (value) {
          _onPopSelected(context, value);
        },
        itemBuilder: (BuildContext context) => menus,
      )
    ];
  }

  void _onPopSelected(BuildContext context, String value) {
    switch (value) {
      case "browser":
        _openWebView(context);
        break;
      case 'share':
        _share(context);
        break;
      case 'follow':
        _follow(context);
        break;
    }
  }

  void _openWebView(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    NavigatorUtil.goWebView(context, bloc.name, bloc.bean.data.htmlUrl);
  }

  void _share(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    ShareUtil.share(bloc.bean.data.htmlUrl);
  }

  void _follow(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    bloc.followOrUnFollow();
  }

  PopupMenuItem _getPopupMenuItem(String value, IconData icon, String title) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        dense: false,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Color(YZColors.textColor),
                size: 22.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                title,
                style: YZStyle.middleText,
              )
            ],
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
}
