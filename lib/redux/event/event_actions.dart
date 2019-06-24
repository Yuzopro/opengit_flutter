import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/refresh_status.dart';

class RequestingEventsAction {}

class ReceivedEventsAction {
  ReceivedEventsAction(this.events, this.refreshStatus);

  final List<EventBean> events;
  final RefreshStatus refreshStatus;
}

class ErrorLoadingEventsAction {}
