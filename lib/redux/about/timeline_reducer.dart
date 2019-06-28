import 'package:open_git/redux/about/timeline_actions.dart';
import 'package:open_git/redux/about/timeline_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "timelineReducer";

final timelineReducer = combineReducers<TimelineState>([
  TypedReducer<TimelineState, RequestingTimelinesAction>(_requestingTimelines),
  TypedReducer<TimelineState, ResetPageAction>(_resetPage),
  TypedReducer<TimelineState, IncreasePageAction>(_increasePage),
  TypedReducer<TimelineState, ReceivedTimelinesAction>(_receivedTimelines),
  TypedReducer<TimelineState, ErrorLoadingTimelinesAction>(_errorLoadingTimelines),
]);

TimelineState _requestingTimelines(TimelineState state, action) {
  LogUtil.v('_requestingTimelines', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.loading,
      refreshStatus: RefreshStatus.idle,
      releases: [],
      page: 1);
}

TimelineState _resetPage(TimelineState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.timeline) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

TimelineState _increasePage(TimelineState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.timeline) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

TimelineState _receivedTimelines(TimelineState state, action) {
  LogUtil.v('_receivedTimelines', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    releases: action.releases,
  );
}

TimelineState _errorLoadingTimelines(TimelineState state, action) {
  LogUtil.v('_errorLoadingTimelines', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
}
