import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/search/search_action.dart';
import 'package:open_git/redux/search/search_state.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "searchReducer";

final searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, RequestingSearchAction>(_requestingSearch),
  TypedReducer<SearchState, ResetPageAction>(_resetPage),
  TypedReducer<SearchState, IncreasePageAction>(_increasePage),
  TypedReducer<SearchState, ReceivedIssueAction>(_receivedSearch),
  TypedReducer<SearchState, ErrorLoadingSearchAction>(_errorLoadingSearch),
]);

SearchState _requestingSearch(SearchState state, action) {
  LogUtil.v('_requestingSearch type is ' + action.type.toString(), tag: TAG);
  if (action.type == ListPageType.search_repos) {
    return state.copyWith(
        status_repos: LoadingStatus.loading,
        refreshStatus_repos: RefreshStatus.idle,
        repos: [],
        page_repos: 1);
  } else if (action.type == ListPageType.search_user) {
    return state.copyWith(
        status_user: LoadingStatus.loading,
        refreshStatus_user: RefreshStatus.idle,
        users: [],
        page_user: 1);
  } else if (action.type == ListPageType.search_issue) {
    return state.copyWith(
        status_issue: LoadingStatus.loading,
        refreshStatus_issue: RefreshStatus.idle,
        issues: [],
        page_issue: 1);
  }
  return state;
}

SearchState _resetPage(SearchState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.search_repos) {
    return state.copyWith(
        page_repos: 1, refreshStatus_repos: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_user) {
    return state.copyWith(page_user: 1, refreshStatus_user: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_issue) {
    return state.copyWith(
        page_issue: 1, refreshStatus_issue: RefreshStatus.idle);
  } else {
    return state;
  }
}

SearchState _increasePage(SearchState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.search_repos) {
    int page = state.page_repos + 1;
    return state.copyWith(
        page_repos: page, refreshStatus_repos: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_user) {
    int page = state.page_user + 1;
    return state.copyWith(
        page_user: page, refreshStatus_user: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_issue) {
    int page = state.page_issue + 1;
    return state.copyWith(
        page_issue: page, refreshStatus_issue: RefreshStatus.idle);
  } else {
    return state;
  }
}

SearchState _receivedSearch(SearchState state, action) {
  LogUtil.v('_receivedEvents', tag: TAG);
  if (action.type == ListPageType.search_user) {
    return state.copyWith(
      status_user: LoadingStatus.success,
      refreshStatus_user: action.refreshStatus,
      users: action.users,
    );
  } else if (action.type == ListPageType.search_repos) {
    return state.copyWith(
      status_repos: LoadingStatus.success,
      refreshStatus_repos: action.refreshStatus,
      repos: action.repos,
    );
  } else if (action.type == ListPageType.search_issue) {
    return state.copyWith(
      status_issue: LoadingStatus.success,
      refreshStatus_issue: action.refreshStatus,
      issues: action.issues,
    );
  }
  return state;
}

SearchState _errorLoadingSearch(SearchState state, action) {
  LogUtil.v('_errorLoadingSearch', tag: TAG);
  if (action.type == ListPageType.search_user) {
    return state.copyWith(
        status_user: LoadingStatus.error,
        refreshStatus_user: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_repos) {
    return state.copyWith(
        status_repos: LoadingStatus.error,
        refreshStatus_repos: RefreshStatus.idle);
  } else if (action.type == ListPageType.search_issue) {
    return state.copyWith(
        status_issue: LoadingStatus.error,
        refreshStatus_issue: RefreshStatus.idle);
  }
  return state;
}
