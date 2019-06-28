import 'package:flutter/widgets.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class EventPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<EventBean> events;
  final Function onRefresh;
  final Function onLoad;

  EventPageViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.events,
      @required this.onRefresh,
      @required this.onLoad});

  static EventPageViewModel fromStore(Store<AppState> store, ListPageType type,
      String reposOwner, String reposName) {
    return EventPageViewModel(
      status: type == ListPageType.event
          ? store.state.eventState.status
          : store.state.eventState.status_repos,
      refreshStatus: type == ListPageType.event
          ? store.state.eventState.refreshStatus
          : store.state.eventState.refreshStatus_repos,
      events: type == ListPageType.event
          ? store.state.eventState.events
          : store.state.eventState.events_repos,
      onRefresh: () {
        store.dispatch(RefreshEventAction(
            RefreshStatus.refresh, type, reposOwner, reposName));
      },
      onLoad: () {
        store.dispatch(RefreshEventAction(
            RefreshStatus.loading, type, reposOwner, reposName));
      },
    );
  }
}
