import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingFollowsAction {
  final ListPageType type;

  RequestingFollowsAction(this.type);
}

class FetchFollowsAction {
  final ListPageType type;

  FetchFollowsAction(this.type);
}

class RefreshFollowsAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;

  RefreshFollowsAction(this.refreshStatus, this.type);
}

class ReceivedFollowsAction {
  final List<UserBean> follows;
  final RefreshStatus refreshStatus;
  final ListPageType type;

  ReceivedFollowsAction(this.follows, this.refreshStatus, this.type);
}

class ErrorLoadingFollowsAction {
  final ListPageType type;

  ErrorLoadingFollowsAction(this.type);
}
