import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/home/home_actions.dart';
import 'package:open_git/redux/home/home_state.dart';
import 'package:open_git/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "homeReducer";

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, RequestingHomesAction>(_requestingHomes),
  TypedReducer<HomeState, ResetPageAction>(_resetPage),
  TypedReducer<HomeState, IncreasePageAction>(_increasePage),
  TypedReducer<HomeState, ReceivedHomesAction>(_receivedHomes),
  TypedReducer<HomeState, UpdateDialogAction>(_updateDialog),
  TypedReducer<HomeState, ErrorLoadingHomesAction>(_errorLoadingHomes),
]);

HomeState _requestingHomes(HomeState state, action) {
  LogUtil.v('_requestingHomes', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.loading,
      refreshStatus: RefreshStatus.idle,
      homes: [],
      page: 1);
}

HomeState _resetPage(HomeState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.home) {
    return state.copyWith(page: 1, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

HomeState _increasePage(HomeState state, action) {
  LogUtil.v('_increasePage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.home) {
    int page = state.page + 1;
    return state.copyWith(page: page, refreshStatus: RefreshStatus.idle);
  } else {
    return state;
  }
}

HomeState _updateDialog(HomeState state, action) {
  LogUtil.v('_updateDialog releaseBean is ' + action.releaseBean.toString(), tag: TAG);
  return state.copyWith(
    releaseBean: action.releaseBean,
  );
}

HomeState _receivedHomes(HomeState state, action) {
  LogUtil.v('_receivedHomes', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    homes: action.homes,
  );
}

HomeState _errorLoadingHomes(HomeState state, action) {
  LogUtil.v('_errorLoadingHomes', tag: TAG);
  return state.copyWith(
      status: LoadingStatus.error, refreshStatus: RefreshStatus.idle);
}
