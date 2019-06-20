import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

class TrendBloc extends BaseListBloc<TrendBean> {
  static final String TAG = "TrendBloc";

  String since, trend;

  initData(String since, String trend) {
    this.since = since;
    this.trend = trend;
  }

  @override
  Future getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return ReposManager.instance.getTrend(since, trend)
        .then((result) {
      if (list == null) {
        list = new List();
      }
      if (page == 1) {
        list.clear();
      }
      list.addAll(result);
      sink.add(UnmodifiableListView<TrendBean>(list));

      if (controller != null) {
        if (!isLoad) {
          controller.refreshCompleted();
          controller.loadNoData();
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
  void initState(BuildContext context) {
  }
}