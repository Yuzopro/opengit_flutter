import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingEventsAction {
  final ListPageType type;

  RequestingEventsAction(this.type);
}

class FetchReposEventAction {
  final String reposOwner;
  final String reposName;
  final ListPageType type;

  FetchReposEventAction(this.reposOwner, this.reposName, this.type);
}

class RefreshEventAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;
  final String reposOwner;
  final String reposName;

  RefreshEventAction(
      this.refreshStatus, this.type, this.reposOwner, this.reposName);
}

class ReceivedEventsAction {
  ReceivedEventsAction(this.events, this.refreshStatus, this.type);

  final List<EventBean> events;
  final RefreshStatus refreshStatus;
  final ListPageType type;
}

class ErrorLoadingEventsAction {
  final ListPageType type;

  ErrorLoadingEventsAction(this.type);
}
