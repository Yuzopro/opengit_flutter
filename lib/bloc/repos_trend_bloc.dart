import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';

class ReposTrendBloc extends BaseListBloc<Repository> {
  final String language;

  ReposTrendBloc(this.language);

  bool _isInit = false;

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchTrendList();
  }

  @override
  Future getData() async {
    await _fetchTrendList();
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_trend;
  }

  Future _fetchTrendList() async {
    try {
      var result = await ReposManager.instance.getLanguages(language, page);
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

      sink.add(UnmodifiableListView<Repository>(list));
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
