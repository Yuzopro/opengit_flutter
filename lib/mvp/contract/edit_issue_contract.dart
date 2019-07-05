import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/mvp/base/base_presenter.dart';
import 'package:open_git/mvp/base/i_base_view.dart';

abstract class IEditIssuePresenter<V extends IEditIssueView> extends BasePresenter<V>{
  editIssue(repoUrl, number, title, body);
}

abstract class IEditIssueView extends IBaseView {
  onEditSuccess(IssueBean issueBean);
}
