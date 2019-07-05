import 'dart:collection';

import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/status/status.dart';

class SearchIssueBloc extends SearchBloc<IssueBean> {
  SearchIssueBloc() : super('issues');

  @override
  ListPageType getListPageType() {
    return ListPageType.search_issue;
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
        IssueBean issue = IssueBean.fromJson(dataItem);
        list.add(issue);
      }
    }

    sink.add(UnmodifiableListView<IssueBean>(list));
  }
}
