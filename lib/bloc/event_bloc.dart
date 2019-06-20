import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/event_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventBloc extends BaseListBloc<EventBean> {
  static final String TAG = "EventBloc";

  final String userName;

  EventBloc(this.userName);

  @override
  Future getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return EventManager.instance.getEventReceived(userName, page)
        .then((result) {
      if (list == null) {
        list = new List();
      }
      if (page == 1) {
        list.clear();
      }
      list.addAll(result);
      sink.add(UnmodifiableListView<EventBean>(list));

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
  void initState(BuildContext context) {
  }
}