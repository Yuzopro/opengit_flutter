import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/issue/issue_actions.dart';
import 'package:open_git/redux/issue/issue_state.dart';
import 'package:open_git/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "issueReducer";

final issueReducer = combineReducers<IssueState>([
  TypedReducer<IssueState, RequestingIssuesAction>(_requestingIssues),
  TypedReducer<IssueState, ResetPageAction>(_resetPage),
  TypedReducer<IssueState, IncreasePageAction>(_increasePage),
  TypedReducer<IssueState, ReceivedIssuesAction>(_receivedIssues),
  TypedReducer<IssueState, RefreshMenuAction>(_refreshMenu),
  TypedReducer<IssueState, ErrorLoadingIssuesAction>(_errorLoadingIssues),
]);

IssueState _requestingIssues(IssueState state, action) {
  LogUtil.v('_requestingEvents', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.loading,
      refreshStatus: RefreshStatus.idle,
      issues: [],
      page: 1);
}

IssueState _resetPage(IssueState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.issue) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

IssueState _increasePage(IssueState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.issue) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

IssueState _receivedIssues(IssueState state, action) {
  LogUtil.v('_receivedEvents', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    issues: action.issues,
  );
}

IssueState _refreshMenu(IssueState state, action) {
  LogUtil.v('_refreshMenu', tag: TAG);
  return state.copyWith(
      q: action.q, state: action.state, sort: action.sort, order: action.order);
}

IssueState _errorLoadingIssues(IssueState state, action) {
  LogUtil.v('_errorLoadingEvents', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
}
