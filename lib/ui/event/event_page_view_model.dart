import 'package:flutter/widgets.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/refresh_status.dart';
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

  static EventPageViewModel fromStore(Store<AppState> store) {
    return EventPageViewModel(
      status: store.state.eventState.status,
      refreshStatus: store.state.eventState.refreshStatus,
      events: store.state.eventState.events,
      onRefresh: () {
        store
            .dispatch(RefreshAction(RefreshStatus.refresh, ListPageType.event));
      },
      onLoad: () {
        store
            .dispatch(RefreshAction(RefreshStatus.loading, ListPageType.event));
      },
    );
  }
}
