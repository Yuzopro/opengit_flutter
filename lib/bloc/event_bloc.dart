import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/event_manager.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';

class EventBloc extends BaseListBloc<EventBean> {
  static final String TAG = "EventBloc";

  final String userName;

  EventBloc(this.userName) {
    LogUtil.v('EventBloc', tag: TAG);
  }

  bool _isInit = false;

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchEventList();
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.event;
  }

  @override
  Future getData() async {
    await _fetchEventList();
  }

  Future _fetchEventList() async {
    LogUtil.v('_fetchEventList', tag: TAG);
    try {
      var result = await EventManager.instance.getEventReceived(userName, page);
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

      sink.add(UnmodifiableListView<EventBean>(list));
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
