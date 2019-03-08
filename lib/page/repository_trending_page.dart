import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/trending_bean.dart';
import 'package:open_git/contract/repository_trending_contract.dart';
import 'package:open_git/presenter/repository_trending_presenter.dart';

class RepositoryTrendingPage extends StatelessWidget {
  final String trending;

  RepositoryTrendingPage(this.trending);

  @override
  Widget build(BuildContext context) {
    final List<_Page> _allPages = [
      new _Page("daily", trending, label: "每日"),
      new _Page("weekly", trending, label: "每周"),
      new _Page("monthly", trending, label: "每月")
    ];

    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text(trending),
            bottom: new TabBar(
              tabs: _allPages
                  .map(
                    (_Page page) => new Tab(text: page.label),
                  )
                  .toList(),
            ),
          ),
          body: new TabBarView(
            children: _allPages.map((_Page page) {
              return page;
            }).toList(),
          ),
        ));
  }
}

class _Page extends StatefulWidget {
  _Page(this.since, this.Trending, {this.label});

  final String label;
  final String since;
  final String Trending;

  String get id => label[0];

  @override
  State<StatefulWidget> createState() {
    return _PageState(since, Trending);
  }
}

class _PageState
    extends BaseState<RepositoryTrendingPresenter, IRepositoryTrendingView> with AutomaticKeepAliveClientMixin
    implements IRepositoryTrendingView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final String since;
  final String Trending;

  List<TrendingBean> _trendingList = new List();

  _PageState(this.since, this.Trending);

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
        child: new Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.builder(
            itemExtent: _TrendingBeanItem.height,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _trendingList.length,
            itemBuilder: (context, index) {
              return new _TrendingBeanItem(
                data: _trendingList[index],
              );
            },
          ),
        ),
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
      await presenter.getReposTrending(since, Trending);
    }
  }
}

class _TrendingBeanItem extends StatelessWidget {
  const _TrendingBeanItem({this.data});

  static const double height = 272.0;
  final TrendingBean data;

  @override
  Widget build(BuildContext context) {
//    print(data);

    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Center(
              child: new Text(
                data.fullName,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
