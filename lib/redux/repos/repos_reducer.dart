import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/repos/repos_actions.dart';
import 'package:open_git/redux/repos/repos_state.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "reposReducer";

final reposReducer = combineReducers<ReposState>([
  TypedReducer<ReposState, RequestingReposAction>(_requestingRepos),
  TypedReducer<ReposState, ResetPageAction>(_resetPage),
  TypedReducer<ReposState, IncreasePageAction>(_increasePage),
  TypedReducer<ReposState, ReceivedReposAction>(_receivedRepos),
  TypedReducer<ReposState, ErrorLoadingReposAction>(_errorLoadingRepos),
]);

ReposState _requestingRepos(ReposState state, action) {
  LogUtil.v('_requestingRepos type ' + action.type.toString(), tag: TAG);
  if (action.type == ListPageType.repos) {
    return state.copyWith(
        status: LoadingStatus.loading,
        refreshStatus: RefreshStatus.idle,
        repos: [],
        page: 1);
  } else if (action.type == ListPageType.repos_user) {
    return state.copyWith(
        status_user: LoadingStatus.loading,
        refreshStatus_user: RefreshStatus.idle,
        repos_user: [],
        page_user: 1);
  } else if (action.type == ListPageType.repos_user_star) {
    return state.copyWith(
        status_user_star: LoadingStatus.loading,
        refreshStatus_user_star: RefreshStatus.idle,
        repos_user_star: [],
        page_user_star: 1);
  } else if (action.type == ListPageType.repos_trend) {
    return state.copyWith(
        status_trend: LoadingStatus.loading,
        refreshStatus_trend: RefreshStatus.idle,
        repos_trend: [],
        page_trend: 1);
  }
  return state;
}

ReposState _resetPage(ReposState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.repos) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user) {
    return state.copyWith(
        page_user: 1, refreshStatus_user_star: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user_star) {
    return state.copyWith(
        page_user_star: 1, refreshStatus_user_star: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_trend) {
    return state.copyWith(
        page_trend: 1, refreshStatus_trend: RefreshStatus.idle);
  }
  return state;
}

ReposState _increasePage(ReposState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.repos) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user) {
    int page = state.page_user + 1;
    return state.copyWith(
        page_user: page, refreshStatus_user: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user_star) {
    int page = state.page_user_star + 1;
    return state.copyWith(
        page_user_star: page, refreshStatus_user_star: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_trend) {
    int page = state.page_trend + 1;
    return state.copyWith(
        page_trend: page, refreshStatus_trend: RefreshStatus.idle);
  }
  return state;
}

ReposState _receivedRepos(ReposState state, action) {
  LogUtil.v('_receivedRepos', tag: TAG);
  if (action.type == ListPageType.repos) {
    return state.copyWith(
      status: LoadingStatus.success,
      refreshStatus: action.refreshStatus,
      repos: action.repos,
    );
  } else if (action.type == ListPageType.repos_user) {
    return state.copyWith(
      status_user: LoadingStatus.success,
      refreshStatus_user: action.refreshStatus,
      repos_user: action.repos,
    );
  } else if (action.type == ListPageType.repos_user_star) {
    return state.copyWith(
      status_user_star: LoadingStatus.success,
      refreshStatus_user_star: action.refreshStatus,
      repos_user_star: action.repos,
    );
  } else if (action.type == ListPageType.repos_trend) {
    return state.copyWith(
      status_trend: LoadingStatus.success,
      refreshStatus_trend: action.refreshStatus,
      repos_trend: action.repos,
    );
  }
  return state;
}

ReposState _errorLoadingRepos(ReposState state, action) {
  LogUtil.v('_errorLoadingRepos', tag: TAG);
  if (action.type == ListPageType.repos) {
    return state.copyWith(
        status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user) {
    return state.copyWith(
        status_user: LoadingStatus.error,
        refreshStatus_user: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_user_star) {
    return state.copyWith(
        status_user_star: LoadingStatus.error,
        refreshStatus_user_star: RefreshStatus.idle);
  } else if (action.type == ListPageType.repos_trend) {
    return state.copyWith(
        status_trend: LoadingStatus.error,
        refreshStatus_trend: RefreshStatus.idle);
  }
  return state;
}
