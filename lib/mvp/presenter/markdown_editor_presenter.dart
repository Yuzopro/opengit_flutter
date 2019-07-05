import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/mvp/contract/markdown_editor_contract.dart';

class MarkdownEditorPresenter extends IMarkdownEditorPresenter {
  @override
  editIssueComment(repoUrl, issueNumber, comment) async {
    if (view != null) {
      view.showLoading();
    }
    final response = await IssueManager.instance
        .editIssueComment(repoUrl, issueNumber, comment);
    if (view != null) {
      view.hideLoading();
      if (response != null) {
        view.onEditSuccess(response);
      }
    }
    return response;
  }

  @override
  addIssueComment(repoUrl, issueNumber, comment) async {
    if (view != null) {
      view.showLoading();
    }
    final response = await IssueManager.instance
        .addIssueComment(repoUrl, issueNumber, comment);
    if (view != null) {
      view.hideLoading();
    }
    return response;
  }
}
