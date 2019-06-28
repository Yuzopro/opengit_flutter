import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/redux/event/event_state.dart';
import 'package:open_git/ui/status/refresh_status.dart';
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
  LogUtil.v('_requestingEvents type is ' + action.type.toString(), tag: TAG);
  if (action.type == ListPageType.event) {
    return state.copyWith(
        status: LoadingStatus.loading,
        refreshStatus: RefreshStatus.idle,
        events: [],
        page: 1);
  } else if (action.type == ListPageType.repos_event) {
    return state.copyWith(
        status_repos: LoadingStatus.loading,
        refreshStatus_repos: RefreshStatus.idle,
        events_repos: [],
        page_repos: 1);
  }
  return state;
}

EventState _resetPage(EventState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.event) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_event) {
    return state.copyWith(
        page_repos: 1, refreshStatus_repos: RefreshStatus.idle);
  } else {
    return state;
  }
}

EventState _increasePage(EventState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.event) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_event) {
    int page = state.page_repos + 1;
    return state.copyWith(
        page_repos: page, refreshStatus_repos: RefreshStatus.idle);
  } else {
    return state;
  }
}

EventState _receivedEvents(EventState state, action) {
  LogUtil.v('_receivedEvents', tag: TAG);
  if (action.type == ListPageType.event) {
    return state.copyWith(
      status: LoadingStatus.success,
      refreshStatus: action.refreshStatus,
      events: action.events,
    );
  } else if (action.type == ListPageType.repos_event) {
    return state.copyWith(
      status_repos: LoadingStatus.success,
      refreshStatus_repos: action.refreshStatus,
      events_repos: action.events,
    );
  }
  return state;
}

EventState _errorLoadingEvents(EventState state, action) {
  LogUtil.v('_errorLoadingEvents', tag: TAG);
  if (action.type == ListPageType.event) {
    return state.copyWith(
        status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_event) {
    return state.copyWith(
        status_repos: LoadingStatus.error,
        refreshStatus_repos: RefreshStatus.idle);
  }
  return state;
}
