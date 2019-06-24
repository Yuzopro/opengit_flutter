import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/redux/event/event_state.dart';
import 'package:open_git/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "eventReducer";

final eventReducer = combineReducers<EventState>([
  TypedReducer<EventState, RequestingEventsAction>(_requestingEvents),
  TypedReducer<EventState, ResetPageAction>(_resetPage),
  TypedReducer<EventState, IncreasePageAction>(_increasePage),
  TypedReducer<EventState, ReceivedEventsAction>(_receivedEvents),
  TypedReducer<EventState, ErrorLoadingEventsAction>(_errorLoadingEvents),
]);

EventState _requestingEvents(EventState state, action) {
  LogUtil.v('_requestingEventsReceivedEventsAction', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.loading,
      refreshStatus: RefreshStatus.idle,
      events: [],
      page: 1);
}

EventState _resetPage(EventState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.home) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

EventState _increasePage(EventState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.home) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

EventState _receivedEvents(EventState state, action) {
  LogUtil.v('_receivedEvents', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    events: action.events,
  );
}

EventState _errorLoadingEvents(EventState state, action) {
  LogUtil.v('_errorLoadingEvents', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
}
