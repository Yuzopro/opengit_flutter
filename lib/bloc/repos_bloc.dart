import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/util/log_util.dart';

abstract class ReposBloc extends BaseListBloc<Repository> {
  static final String TAG = "ReposBloc";

  final String userName;
  final bool isStar;

  ReposBloc(this.userName, {this.isStar}) {
    LogUtil.v('ReposBloc', tag: TAG);
  }

  bool _isInit = false;

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchReposList();
  }

  @override
  Future getData() async {
    await _fetchReposList();
  }

  Future _fetchReposList() async {
    LogUtil.v('_fetchReposList', tag: TAG);
    try {
      var result =
          await UserManager.instance.getUserRepos(userName, page, null, isStar);
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
