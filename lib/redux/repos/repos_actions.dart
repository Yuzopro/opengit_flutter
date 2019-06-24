import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/refresh_status.dart';

class RequestingReposAction {
  final ListPageType type;

  RequestingReposAction(this.type);
}

class FetchReposAction {
  final ListPageType type;

  FetchReposAction(this.type);
}

class RefreshReposAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;

  RefreshReposAction(this.refreshStatus, this.type);
}

class ReceivedReposAction {
  final List<Repository> repos;
  final RefreshStatus refreshStatus;
  final ListPageType type;

  ReceivedReposAction(this.repos, this.refreshStatus, this.type);
}

class ErrorLoadingReposAction {
  final ListPageType type;

  ErrorLoadingReposAction(this.type);
}
