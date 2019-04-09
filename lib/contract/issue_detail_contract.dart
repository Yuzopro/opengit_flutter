import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';

abstract class IIssueDetailPresenter<V extends IIssueDetailView>
    extends BasePresenter<V> {
  getSingleIssue(repoUrl, number);

  getIssueComment(repoUrl, issueNumber, page, isFromMore);

  String getReposFullName(String repoUrl);

  String getRepoAuthorName(String repoUrl);

  editReactions(IssueBean item, reposName, comment, isIssue);

  isEditAndDeleteEnable(IssueBean issueBean, IssueBean item);

  deleteIssueComment(IssueBean issueBean, repoUrl, comment_id);
}

abstract class IIssueDetailView extends IBasePullListView<IssueBean> {
  void onEditSuccess(IssueBean issueBean);

  void onDeleteSuccess(IssueBean issueBean);

  void onGetSingleIssueSuccess(IssueBean issueBean);
}
