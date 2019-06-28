import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class EventState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<EventBean> events;
  final int page;

  final LoadingStatus status_repos;
  final RefreshStatus refreshStatus_repos;
  final List<EventBean> events_repos;
  final int page_repos;

  EventState(
      {this.status,
      this.refreshStatus,
      this.events,
      this.page,
      this.status_repos,
      this.refreshStatus_repos,
      this.events_repos,
      this.page_repos});

  factory EventState.initial() {
    return EventState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      events: [],
      page: 1,
      status_repos: LoadingStatus.idle,
      refreshStatus_repos: RefreshStatus.idle,
      events_repos: [],
      page_repos: 1,
    );
  }

  EventState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<EventBean> events,
      int page,
      LoadingStatus status_repos,
      RefreshStatus refreshStatus_repos,
      List<EventBean> events_repos,
      int page_repos}) {
    return EventState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      events: events ?? this.events,
      page: page ?? this.page,
      status_repos: status_repos ?? this.status_repos,
      refreshStatus_repos: refreshStatus_repos ?? this.refreshStatus_repos,
      events_repos: events_repos ?? this.events_repos,
      page_repos: page_repos ?? this.page_repos,
    );
  }

  @override
  String toString() {
    return 'EventState{page: $page}';
  }
}
