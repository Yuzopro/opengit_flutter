import 'package:open_git/contract/issue_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class IssuePresenter extends IIssuePresenter {
  @override
  getIssue(q, state, sort, order, userName, page, isFromMore) async {
//    return IssueManager.instance.getIssue(q, state, sort, order, userName, page,
//        (data) {
//      List<IssueBean> list = new List();
//      var items = data["items"];
//      if (items != null && items.length > 0) {
//        for (int i = 0; i < items.length; i++) {
//          list.add(IssueBean.fromJson(items[i]));
//        }
//      }
//      if (view != null) {
//        view.setList(list, isFromMore);
//      }
//    }, (code, msg) {});
    final response = await IssueManager.instance
        .getIssue(q, state, sort, order, userName, page);
    if (response != null && view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }

  @override
  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
  }
}
