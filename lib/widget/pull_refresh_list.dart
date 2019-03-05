import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/common/config.dart';

abstract class PullRefreshListState<T, P extends BasePresenter<V>,
        V extends IBasePullListView> extends BaseState<P, V>
    implements IBasePullListView<T> {
  List<T> _list = [];

  final ScrollController _scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool isLoading = false;
  bool isNoMore = false;

  Future<Null> onRefresh();

  getMoreData();

  Widget getItemRow(T item);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50 && !isNoMore) {
        _loadMore();
      }
    });

    _showRefreshLoading();
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _list.length == 0
              ? 0
              : isLoading ? _list.length + 1 : _list.length,
          itemBuilder: (context, index) {
            return _getRow(context, index);
          },
        ),
        onRefresh: onRefresh);
  }

  @override
  void dispose() {
    print("RefreshListPage _dispose()");
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void setList(List<T> list, bool isFromMore) {
    int size = 0;
    if (list != null && list.length > 0) {
      size = list.length;
      if (size < Config.PAGE_SIZE) {
        isNoMore = true;
      } else {
        isNoMore = false;
      }

      if (!isFromMore) {
        _list.clear();
      } else {
        isLoading = false;
      }
      _list.addAll(list);
    }
    setState(() {});
  }

  void _showRefreshLoading() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  void _loadMore() async {
    print("RefreshListPage _loadMore()");
    if (!isLoading) {
      isLoading = true;
      setState(() {});

      getMoreData();
    }
  }

  Widget _getRow(BuildContext context, int index) {
    if (index < _list.length) {
      return getItemRow(_list[index]);
    }
    return _getMoreWidget();
  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isNoMore
                ? Text("")
                : SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                        strokeWidth: 4.0,
//                  backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation(Colors.black)),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Text(
                isNoMore ? "没有更多数据" : "加载中...",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
