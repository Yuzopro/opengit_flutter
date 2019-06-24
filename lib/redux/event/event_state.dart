import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/refresh_status.dart';

class EventState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<EventBean> events;
  final int page;

  EventState(
      {this.status,
      this.refreshStatus,
      this.events,
      this.page});

  factory EventState.initial() {
    return EventState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      events: [],
      page: 1,
    );
  }

  EventState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<EventBean> events,
      int page}) {
    return EventState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      events: events ?? this.events,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return 'EventState{page: $page}';
  }
}
