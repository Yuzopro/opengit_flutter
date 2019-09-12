import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/common/config.dart';

class SearchIssueBloc extends SearchBloc<IssueBean> {
  SearchIssueBloc() : super('issues');

  @override
  void dealResult(result) {
    if (bean.data == null) {
      bean.data = List();
    }
    if (page == 1) {
      bean.data.clear();
    }

    noMore = true;
    if (result != null && result.length > 0) {
      var items = result["items"];
      noMore = items.length != Config.PAGE_SIZE;
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        IssueBean issue = IssueBean.fromJson(dataItem);
        bean.data.add(issue);
      }
    } else {
      bean.isError = true;
    }

    sink.add(bean);
  }
}
