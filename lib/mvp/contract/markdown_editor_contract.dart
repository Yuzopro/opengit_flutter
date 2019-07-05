import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/mvp/base/base_presenter.dart';
import 'package:open_git/mvp/base/i_base_view.dart';

abstract class IMarkdownEditorPresenter<V extends IMarkdownEditorView> extends BasePresenter<V>{
  editIssueComment(repoUrl, issueNumber, comment);
  addIssueComment(repoUrl, issueNumber, comment);
}

abstract class IMarkdownEditorView extends IBaseView {
    onEditSuccess(IssueBean issueBean);
}
