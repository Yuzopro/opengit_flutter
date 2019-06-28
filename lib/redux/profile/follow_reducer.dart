import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/profile/follow_actions.dart';
import 'package:open_git/redux/profile/follow_state.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "followReducer";

final followReducer = combineReducers<FollowState>([
  TypedReducer<FollowState, RequestingFollowsAction>(_requestingFollows),
  TypedReducer<FollowState, ResetPageAction>(_resetPage),
  TypedReducer<FollowState, IncreasePageAction>(_increasePage),
  TypedReducer<FollowState, ReceivedFollowsAction>(_receivedFollows),
  TypedReducer<FollowState, ErrorLoadingFollowsAction>(_errorLoadingFollows),
]);

FollowState _requestingFollows(FollowState state, action) {
  LogUtil.v('_requestingFollows type ' + action.type.toString(), tag: TAG);
  if (action.type == ListPageType.follower) {
    return state.copyWith(
        status_follow: LoadingStatus.loading,
        refreshStatus_follow: RefreshStatus.idle,
        user_follow: [],
        page_follow: 1);
  } else if (action.type == ListPageType.by_follower) {
    return state.copyWith(
        status_by_follow: LoadingStatus.loading,
        refreshStatus_by_follow: RefreshStatus.idle,
        user_by_follow: [],
        page_by_follow: 1);
  }
  return state;
}

FollowState _resetPage(FollowState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.follower) {
    return state.copyWith(
        page_follow: 1, refreshStatus_follow: RefreshStatus.idle);
  } else if (action.type == ListPageType.by_follower) {
    return state.copyWith(
        page_by_follow: 1, refreshStatus_by_follow: RefreshStatus.idle);
  }
  return state;
}

FollowState _increasePage(FollowState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.follower) {
    int page = state.page_follow + 1;
    return state.copyWith(
        page_follow: page, refreshStatus_follow: RefreshStatus.idle);
  } else if (action.type == ListPageType.by_follower) {
    int page = state.page_by_follow + 1;
    return state.copyWith(
        page_by_follow: page, refreshStatus_by_follow: RefreshStatus.idle);
  }
  return state;
}

FollowState _receivedFollows(FollowState state, action) {
  LogUtil.v('_receivedFollows', tag: TAG);
  if (action.type == ListPageType.follower) {
    return state.copyWith(
      status_follow: LoadingStatus.success,
      refreshStatus_follow: action.refreshStatus,
      user_follow: action.follows,
    );
  } else if (action.type == ListPageType.by_follower) {
    return state.copyWith(
      status_by_follow: LoadingStatus.success,
      refreshStatus_by_follow: action.refreshStatus,
      user_by_follow: action.follows,
    );
  }
  return state;
}

FollowState _errorLoadingFollows(FollowState state, action) {
  LogUtil.v('_errorLoadingFollows', tag: TAG);
  if (action.type == ListPageType.follower) {
    return state.copyWith(
        status_follow: LoadingStatus.error,
        refreshStatus_follow: RefreshStatus.idle);
  } else if (action.type == ListPageType.by_follower) {
    return state.copyWith(
        status_by_follow: LoadingStatus.error,
        refreshStatus_by_follow: RefreshStatus.idle);
  }
  return state;
}
