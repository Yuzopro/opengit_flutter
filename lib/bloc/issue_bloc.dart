import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

import 'base_list_bloc.dart';

class IssueBloc extends BaseListBloc<IssueBean> {
  static final String TAG = "IssueBloc";

  final String userName;
  String q, state, sort, order;

  IssueBloc(this.userName);

  initData(String q, String state, String sort, String order) {
    this.q = q;
    this.state = state;
    this.sort = sort;
    this.order = order;
  }

  @override
  Future getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return IssueManager.instance
        .getIssue(q, state, sort, order, userName, page)
        .then((result) {
      if (list == null) {
        list = new List();
      }
      if (page == 1) {
        list.clear();
      }
      list.addAll(result);
      sink.add(UnmodifiableListView<IssueBean>(list));

      if (controller != null) {
        if (!isLoad) {
          controller.refreshCompleted();
          controller.loadComplete();
        } else {
          controller.loadComplete();
        }
      }
    }).catchError((_) {
      page--;
      if (controller != null) {
        controller.loadFailed();
      }
    });
  }

  @override
  void initState(BuildContext context) {}
}
