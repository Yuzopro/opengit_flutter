import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';

abstract class IIssuePresenter<V extends IIssueView> extends BasePresenter<V> {
  getIssue(q, state, sort, order, userName, page, isFromMore);
  String getReposFullName(String repoUrl);
}

abstract class IIssueView extends IBasePullListView<IssueBean> {}
