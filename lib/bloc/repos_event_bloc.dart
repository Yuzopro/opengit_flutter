import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';

class ReposEventBloc extends BaseListBloc<EventBean> {
  final String reposOwner;
  final String reposName;

  ReposEventBloc(this.reposOwner, this.reposName);

  bool _isInit = false;

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchEventList();
  }

  @override
  Future getData() async {
    await _fetchEventList();
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_event;
  }

  Future _fetchEventList() async {
    try {
      var result = await ReposManager.instance
          .getReposEvents(reposOwner, reposName, page);
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
