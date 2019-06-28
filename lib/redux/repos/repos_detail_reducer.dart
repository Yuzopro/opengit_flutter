import 'package:open_git/redux/repos/repos_detail_action.dart';
import 'package:open_git/redux/repos/repos_detail_state.dart';
import 'package:open_git/ui/repos/repos_status.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "reposDetailReducer";

final reposDetailReducer = combineReducers<ReposDetailState>([
  TypedReducer<ReposDetailState, RequestingReposDetailAction>(
      _requestingReposDetail),
  TypedReducer<ReposDetailState, ReceivedReposDetailAction>(
      _receivedReposDetail),
  TypedReducer<ReposDetailState, ErrorLoadingReposDetailAction>(
      _errorLoadingReposDetail),
  TypedReducer<ReposDetailState, ReceivedStarStatusAction>(_receivedStarStatus),
  TypedReducer<ReposDetailState, ReceivedWatchStatusAction>(
      _receivedWatchStatus),
  TypedReducer<ReposDetailState, ReceivedReadmeAction>(_receivedReadme),
  TypedReducer<ReposDetailState, ReceivedBranchsAction>(_receivedBranchs),
  TypedReducer<ReposDetailState, ChangeReposStarStatusAction>(
      _changeStarStatus),
  TypedReducer<ReposDetailState, ChangeReposWatchStatusAction>(
      _changeWatchStatus),
]);

ReposDetailState _requestingReposDetail(ReposDetailState state, action) {
  LogUtil.v('_requestingReposDetail', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.loading,
    refreshStatus: RefreshStatus.idle,
    repos: null,
    starStatus: ReposStatus.loading,
    watchStatus: ReposStatus.loading,
  );
}

ReposDetailState _receivedReposDetail(ReposDetailState state, action) {
  LogUtil.v('_receivedReposDetail', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    repos: action.repos,
  );
}

ReposDetailState _receivedStarStatus(ReposDetailState state, action) {
  LogUtil.v('_receivedStarStatus', tag: TAG);
  return state.copyWith(
    starStatus: action.starStatus,
  );
}

ReposDetailState _receivedWatchStatus(ReposDetailState state, action) {
  LogUtil.v('_receivedWatchStatus', tag: TAG);
  return state.copyWith(
    watchStatus: action.watchStatus,
  );
}

ReposDetailState _receivedReadme(ReposDetailState state, action) {
  LogUtil.v('_receivedReadme', tag: TAG);
  return state.copyWith(
    readme: action.readme,
  );
}

ReposDetailState _receivedBranchs(ReposDetailState state, action) {
  LogUtil.v('_receivedBranchs', tag: TAG);
  return state.copyWith(
    branchs: action.branchs,
  );
}

ReposDetailState _changeStarStatus(ReposDetailState state, action) {
  LogUtil.v('_changeStarStatus', tag: TAG);
  return state.copyWith(
    starStatus: ReposStatus.loading,
  );
}

ReposDetailState _changeWatchStatus(ReposDetailState state, action) {
  LogUtil.v('_changeWatchStatus', tag: TAG);
  return state.copyWith(
    watchStatus: ReposStatus.loading,
  );
}

ReposDetailState _errorLoadingReposDetail(ReposDetailState state, action) {
  LogUtil.v('_errorLoadingReposDetail', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
}
