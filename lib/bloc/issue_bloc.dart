import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';

import 'base_list_bloc.dart';

class IssueBloc extends BaseListBloc<IssueBean> {
  static final String TAG = "IssueBloc";

  final String userName;
  String q, state, sort, order;

  bool _isInit = false;

  IssueBloc(this.userName) {
    LogUtil.v('IssueBloc', tag: TAG);
    q = "involves";
    state = "open";
    sort = "created";
    order = "asc";
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.issue;
  }

  initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchIssueList();
  }

  refreshData({String q, String state, String sort, String order}) {
    this.q = q ?? this.q;
    this.state = state ?? this.state;
    this.sort = sort ?? this.sort;
    this.order = order ?? this.order;
    sink.add(null);
    _fetchIssueList();
  }

  @override
  Future getData() async {
    await _fetchIssueList();
  }

  Future _fetchIssueList() async {
    LogUtil.v('_fetchIssueList', tag: TAG);
    try {
      var result = await IssueManager.instance
          .getIssue(q, state, sort, order, userName, page);
      if (list == null) {
        list = List();
      }
      if (page == 1) {
        list.clear();
      }

      noMore = true;
      if (result != null) {
        noMore = result.length != Config.PAGE_SIZE;
        list.addAll(result);
      }

      sink.add(UnmodifiableListView<IssueBean>(list));
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
