import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/markdown_editor_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class MarkdownEditorPresenter extends IMarkdownEditorPresenter {
  @override
  editIssueComment(repoUrl, issueNumber, comment) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance
        .editIssueComment(repoUrl, issueNumber, comment, (data) {
      if (view != null) {
        IssueBean issueBean = IssueBean.fromJson(data);
        view.onEditSuccess(issueBean);
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  @override
  addIssueComment(repoUrl, issueNumber, comment) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance.addIssueComment(
        repoUrl, issueNumber, comment, (data) {
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
