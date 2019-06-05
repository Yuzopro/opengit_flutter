import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/trending_bean.dart';
import 'package:open_git/contract/repository_trending_contract.dart';
import 'package:open_git/presenter/repository_trending_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/route/navigator_util.dart';

class TrendPage extends StatefulWidget {
  final String trending;

  TrendPage(this.trending);

  @override
  State<StatefulWidget> createState() {
    return _TrendState();
  }
}

class _TrendState extends State<TrendPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<_Page> _allPages;
  final PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();

    _allPages = [
      new _Page("daily", widget.trending, label: "每日"),
      new _Page("weekly", widget.trending, label: "每周"),
      new _Page("monthly", widget.trending, label: "每月")
    ];

    _tabController = new TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text(widget.trending),
            bottom: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: _allPages
                  .map(
                    (_Page page) => new Tab(text: page.label),
                  )
                  .toList(),
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
            ),
          ),
          body: new PageView(
            controller: _pageController,
            children: _allPages.map((_Page page) {
              return page;
            }).toList(),
          ),
        ));
  }
}

class _Page extends StatefulWidget {
  _Page(this.since, this.trending, {this.label});

  final String label;
  final String since;
  final String trending;

  @override
  State<StatefulWidget> createState() {
    return _PageState(since, trending);
  }
}

class _PageState extends BaseState<_Page, RepositoryTrendingPresenter,
        IRepositoryTrendingView>
    with AutomaticKeepAliveClientMixin
    implements IRepositoryTrendingView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final String since;
  final String trending;

  List<TrendingBean> _trendingList = new List();

  _PageState(this.since, this.trending);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: new ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _trendingList.length,
            itemBuilder: (context, index) {
              return new _TrendingBeanItem(
                trending,
                data: _trendingList[index],
              );
            }),
        onRefresh: _onRefresh);
  }

  @override
  RepositoryTrendingPresenter initPresenter() {
    return new RepositoryTrendingPresenter();
  }

  @override
  void initState() {
    super.initState();
    _showRefreshLoading();
  }

  @override
  void setTrendingList(List<TrendingBean> list) {
    _trendingList.clear();
    _trendingList.addAll(list);
    setState(() {});
  }

  void _showRefreshLoading() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  Future<Null> _onRefresh() async {
    if (presenter != null) {
      await presenter.getReposTrending(since, trending);
    }
  }
}

class _TrendingBeanItem extends StatelessWidget {
  const _TrendingBeanItem(this.trending, {this.data});

  final TrendingBean data;
  final String trending;

  @override
  Widget build(BuildContext context) {
    List<Widget> _bottomViews = new List();
    if (data.language != null && data.language.isNotEmpty) {
      _bottomViews.add(_getItemLanguage(data.language));
    }

    Widget _starView = new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(
              width: 16.0,
              height: 16.0,
              image: new AssetImage('image/ic_star.png')),
          Text(
            data.starCount,
            style: new TextStyle(color: Colors.black, fontSize: 10.0),
          ),
        ],
      ),
    );
    _bottomViews.add(_starView);

    Widget _forkView = new Row(
      children: <Widget>[
        Image(
            width: 16.0,
            height: 16.0,
            image: new AssetImage('image/ic_branch.png')),
        Text(
          data.forkCount,
          style: new TextStyle(color: Colors.black, fontSize: 10.0),
        ),
      ],
    );
    _bottomViews.add(_forkView);

    Widget _builtByView = _getBuiltByWidget();
    _bottomViews.add(_builtByView);

    return new InkWell(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data.fullName,
                style: new TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(data.description,
                    style: new TextStyle(color: Colors.grey))),
            Row(
              children: _bottomViews,
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, data.name, data.reposName,
            trending.toLowerCase() == "all");
      },
    );
  }

  Widget _getItemLanguage(String language) {
    return new Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: new Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Colors.black87,
              width: 8.0,
              height: 8.0,
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              language,
              style: new TextStyle(color: Colors.black54, fontSize: 10.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBuiltByWidget() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Built by",
              style: new TextStyle(color: Colors.grey, fontSize: 10.0)),
          Row(
            children: data.contributors
                .map(
                  (String url) => new Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: new ClipOval(
                          child: ImageUtil.getImageWidget(url ?? "", 12.0),
                        ),
                      ),
                )
                .toList(),
          )
        ],
      ),
      flex: 1,
    );
  }
}
