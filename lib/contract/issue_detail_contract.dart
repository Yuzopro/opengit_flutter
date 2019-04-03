import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';

abstract class IIssueDetailPresenter<V extends IIssueDetailView> extends BasePresenter<V> {
  getIssueComment(repoUrl, issueNumber, page, isFromMore);
  String getReposFullName(String repoUrl);
  addIssueComment(repoUrl, issueNumber, comment);
  editReactions(IssueBean item, reposName, comment);
  isEditAndDeleteEnable(IssueBean item);
}

abstract class IIssueDetailView extends IBasePullListView<IssueBean> {
  void onEditSuccess(IssueBean issueBean);
}
