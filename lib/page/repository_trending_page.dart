import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/trending_bean.dart';
import 'package:open_git/contract/repository_trending_contract.dart';
import 'package:open_git/presenter/repository_trending_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';

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
    extends BaseState<RepositoryTrendingPresenter, IRepositoryTrendingView>
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
    return new FlatButton(
        onPressed: () {
          NavigatorUtil.goReposDetail(context, data.name, data.reposName, trending.toLowerCase().compareTo("all") == 0);
        },
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.fullName,
                      style: new TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(data.description,
                      style: new TextStyle(color: Colors.grey)),
                  Row(
                    children: <Widget>[
                      _getItemLanguage(data.language),
                      _getItemBottom(
                          Icon(
                            Icons.star_border,
                            color: Colors.black,
                            size: 12.0,
                          ),
                          data.starCount),
                      _getItemBottom(
                          Image.asset(
                            "image/ic_branch.png",
                            width: 10.0,
                            height: 10.0,
                          ),
                          data.forkCount),
                      _getBuiltByWidget(),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 0.3,
            )
          ],
        ));
  }

  Widget _getItemLanguage(String language) {
    return new Row(
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
            style: new TextStyle(color: Colors.black54, fontSize: 12.0),
          ),
        ),
      ],
    );
  }

  Widget _getItemBottom(Widget icon, String count) {
    return new Padding(
      padding: new EdgeInsets.only(left: 12.0),
      child: Row(
        children: <Widget>[
          icon,
          Text(
            count,
            style: new TextStyle(color: Colors.black, fontSize: 12.0),
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
          Text("Built by", style: new TextStyle(color: Colors.grey)),
          Row(
            children: data.contributors
                .map(
                  (String url) => new Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: new ClipOval(
                          child: ImageUtil.getImageWidget(url ?? "", 18.0),
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
