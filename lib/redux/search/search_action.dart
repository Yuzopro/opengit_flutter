import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';

class FetchSearchAction {
  final String query;
  final ListPageType type;

  FetchSearchAction(this.query, this.type);
}

class RequestingSearchAction {
  final ListPageType type;

  RequestingSearchAction(this.type);
}

class ReceivedIssueAction {
  final List<Repository> repos;
  final List<UserBean> users;
  final List<IssueBean> issues;
  final RefreshStatus refreshStatus;
  final ListPageType type;

  ReceivedIssueAction(this.repos, this.users, this.issues, this.refreshStatus, this.type);
}

class ErrorLoadingSearchAction {
  final ListPageType type;

  ErrorLoadingSearchAction(this.type);
}
