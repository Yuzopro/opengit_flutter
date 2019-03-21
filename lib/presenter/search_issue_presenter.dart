import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/presenter/search_presenter.dart';

class SearchIssuePresenter extends SearchPresenter {
  @override
  void dealResult(data, isFromMore) {
    if (data != null && data.length > 0) {
      List<IssueBean> list = new List();
      var items = data["items"];
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        IssueBean issue = IssueBean.fromJson(dataItem);
        list.add(issue);
      }
      if (view != null) {
        view.setList(list, isFromMore);
      }
    }
  }

  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
  }
}
