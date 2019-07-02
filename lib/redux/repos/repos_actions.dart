import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingReposAction {
  final ListPageType type;

  RequestingReposAction(this.type);
}

class FetchReposAction {
  final ListPageType type;
  final String userName;

  FetchReposAction(this.type, this.userName);
}

class FetchReposTrendAction {
  final String language;

  FetchReposTrendAction(this.language);
}

class RefreshReposAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;
  final String language;
  final String userName;

  RefreshReposAction(this.refreshStatus, this.type, this.language, this.userName);
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
