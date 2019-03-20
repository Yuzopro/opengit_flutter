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

  int page = 1;

  final ScrollController _scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool isLoading = false;
  bool isNoMore = false;

  Future<Null> onRefresh();

  Widget getItemRow(T item);

  Widget getHeader() {
    return null;
  }

  bool isSupportLoadMore() {
    return true;
  }

  getMoreData() {
    return null;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50 &&
          !isNoMore &&
          isSupportLoadMore()) {
        _loadMore();
      }
    });

    showRefreshLoading();
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: ListView.builder(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _getListItemCount(),
          itemBuilder: (context, index) {
            return _getRow(context, index);
          },
        ),
        onRefresh: onRefresh);
  }

  @override
  void dispose() {
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

  void showRefreshLoading() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  void _loadMore() async {
    if (!isLoading) {
      isLoading = true;
      setState(() {});

      getMoreData();
    }
  }

  Widget _getRow(BuildContext context, int index) {
    if (getHeader() != null && index == 0) {
      return getHeader();
    }
    if (_list.length == 0) {
      return _getEmptyWidget();
    }
    if (index < (getHeader() != null ? _list.length + 1 : _list.length)) {
      if (getHeader() != null) {
        index -= 1;
      }
      return getItemRow(_list[index]);
    }
    return _getMoreWidget();
  }

  Widget _getEmptyWidget() {
    return new Center(
      child: FlatButton(
          onPressed: () {
            showRefreshLoading();
          },
          child: Text("数据暂时为空")),
    );
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

  int _getListItemCount() {
    int count = _list.length;
    if (count == 0) {
      count += 1;
    }
    if (getHeader() != null) {
      count += 1;
    }
    if (isLoading) {
      count += 1;
    }
    if (isNoMore) {
      count += 1;
    }
    return count;
  }
}
