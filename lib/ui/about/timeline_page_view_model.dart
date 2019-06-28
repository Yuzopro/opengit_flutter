import 'package:flutter/widgets.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class TimelineViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<ReleaseBean> releases;
  final Function onRefresh;
  final Function onLoad;

  TimelineViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.releases,
      @required this.onRefresh,
      @required this.onLoad});

  static TimelineViewModel fromStore(Store<AppState> store) {
    return TimelineViewModel(
      status: store.state.timelineState.status,
      refreshStatus: store.state.timelineState.refreshStatus,
      releases: store.state.timelineState.releases,
      onRefresh: () {
        store.dispatch(
            RefreshAction(RefreshStatus.refresh, ListPageType.timeline));
      },
      onLoad: () {
        store.dispatch(
            RefreshAction(RefreshStatus.loading, ListPageType.timeline));
      },
    );
  }
}
