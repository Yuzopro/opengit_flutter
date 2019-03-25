import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';

abstract class IIssueDetailPresenter<V extends IIssueDetailView> extends BasePresenter<V> {
  getIssueComment(repoUrl, issueNumber, page, isFromMore);
  String getReposFullName(String repoUrl);
}

abstract class IIssueDetailView extends IBasePullListView<IssueBean> {}
