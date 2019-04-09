import 'package:open_git/contract/edit_issue_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class EditIssuePresenter extends IEditIssuePresenter {
  @override
  editIssue(repoUrl, number, title, body) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance.editIssue(repoUrl, number, title, body,
        (data) {
      if (view != null) {
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }
}
