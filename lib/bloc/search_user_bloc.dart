import 'dart:collection';

import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/status/status.dart';

class SearchUserBloc extends SearchBloc<UserBean> {
  SearchUserBloc() : super('users');

  @override
  ListPageType getListPageType() {
    return ListPageType.search_user;
  }

  @override
  void dealResult(result) {
    if (list == null) {
      list = List();
    }
    if (page == 1) {
      list.clear();
    }

    noMore = true;
    if (result != null && result.length > 0) {
      var items = result["items"];
      noMore = items.length != Config.PAGE_SIZE;
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        UserBean user = UserBean.fromJson(dataItem);
        list.add(user);
      }
    }

    sink.add(UnmodifiableListView<UserBean>(list));
  }
}
