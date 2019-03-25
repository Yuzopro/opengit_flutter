import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/issue_detail_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class IssueDetailPresenter extends IIssueDetailPresenter {
  @override
  getIssueComment(repoUrl, issueNumber, page, isFromMore) {
    return IssueManager.instance
        .getIssueComment(repoUrl, issueNumber, page, (data) {
      if (data != null && data.length > 0) {
        List<IssueBean> list = new List();
        int length = data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(data[i]));
        }
        if (view != null) {
          view.setList(list, isFromMore);
        }
      }
    }, (code, msg) {});
  }

  @override
  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("/") + 1)
        : "";
  }
}
