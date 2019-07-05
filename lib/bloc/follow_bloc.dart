import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/util/log_util.dart';

abstract class FollowBloc extends BaseListBloc<UserBean> {
  static final String TAG = "FollowBloc";

  final String userName;

  bool _isInit = false;

  FollowBloc(this.userName);

  fetchList(String userName, int page);

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchFollowList();
  }

  @override
  Future getData() async {
    await _fetchFollowList();
  }

  Future _fetchFollowList() async {
    LogUtil.v('_fetchFollowList', tag: TAG);
    try {
      var result = await fetchList(userName, page);
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

      sink.add(UnmodifiableListView<UserBean>(list));
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
