import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/page/repository_page.dart';
import 'package:open_git/page/user_follow_page.dart';

class UserProfilePage extends StatefulWidget {
  final UserBean userBean;

  UserProfilePage(this.userBean);

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState(userBean);
  }
}

class _UserProfileState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  final UserBean userBean;

  String _userAvatar;

  _UserProfileState(this.userBean);

  List<Choice> _choices;

  TabController _tabController;
  final PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();

    _choices = <Choice>[
      Choice(title: '项目', widget: RepositoryPage(userBean, false)),
      Choice(title: 'Star过的项目', widget: RepositoryPage(userBean, true)),
      Choice(title: '关注我的', widget: UserFollowPage(userBean, false)),
      Choice(title: '我关注的', widget: UserFollowPage(userBean, true)),
      Choice(title: '所在组织', widget: RepositoryPage(userBean, false)),
    ];

    if (userBean != null) {
      _userAvatar = userBean.avatarUrl ?? "";
    }

    _tabController = new TabController(vsync: this, length: _choices.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            }).toList()),
      )),
    );
  }

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
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: _choices.map((Choice choice) {
            return new Tab(
              text: choice.title,
            );
          }).toList(),
          onTap: (index) {
            _pageController.jumpToPage(index);
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
