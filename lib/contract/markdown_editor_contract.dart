import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';
import 'package:open_git/bean/issue_bean.dart';

abstract class IMarkdownEditorPresenter<V extends IMarkdownEditorView> extends BasePresenter<V>{
  editIssueComment(repoUrl, issueNumber, comment);
}

abstract class IMarkdownEditorView extends IBaseView {
    onEditSuccess(IssueBean issueBean);
}
