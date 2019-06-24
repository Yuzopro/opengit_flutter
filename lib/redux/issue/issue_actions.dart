import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/refresh_status.dart';

class RequestingIssuesAction {}

class ReceivedIssuesAction {
  ReceivedIssuesAction(this.issues, this.refreshStatus);

  final List<IssueBean> issues;
  final RefreshStatus refreshStatus;
}

class RefreshMenuAction {
  final String q, state, sort, order;

  RefreshMenuAction(this.q, this.state, this.sort, this.order);
}

class ErrorLoadingIssuesAction {}
