import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReposBloc extends BaseListBloc<Repository> {
  static final String TAG = "ReposBloc";

  final String userName;
  final bool isStar;

  ReposBloc(this.userName, this.isStar);

  @override
  void initState(BuildContext context) {

  }

  @override
  Future getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return UserManager.instance
        .getUserRepos(userName, page, null, isStar)
        .then((result) {
      if (list == null) {
        list = new List();
      }
      if (page == 1) {
        list.clear();
      }
      list.addAll(result);
      sink.add(UnmodifiableListView<Repository>(list));

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
}
