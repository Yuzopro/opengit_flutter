import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/trend/trend_actions.dart';
import 'package:open_git/redux/trend/trend_state.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "trendReducer";

final trendReducer = combineReducers<TrendState>([
  TypedReducer<TrendState, RequestingTrendsAction>(_requestingTrends),
  TypedReducer<TrendState, ResetPageAction>(_resetPage),
  TypedReducer<TrendState, ReceivedTrendsAction>(_receivedTrends),
  TypedReducer<TrendState, ErrorLoadingTrendsAction>(_errorLoadingTrends),
]);

TrendState _requestingTrends(TrendState state, action) {
  LogUtil.v('_requestingTrends type is ' + action.type.toString(), tag: TAG);
  if (action.type == ListPageType.day_trend) {
    return state.copyWith(dayStatus: LoadingStatus.loading, dayTrends: []);
  } else if (action.type == ListPageType.week_trend) {
    return state.copyWith(weekStatus: LoadingStatus.loading, weekTrends: []);
  } else if (action.type == ListPageType.month_trend) {
    return state.copyWith(monthStatus: LoadingStatus.loading, monthTrends: []);
  }
  return state;
}

TrendState _resetPage(TrendState state, action) {
  LogUtil.v('_resetPage state is ' + state.toString(), tag: TAG);
  if (action.type == ListPageType.day_trend) {
    return state.copyWith(dayRefreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.week_trend) {
    return state.copyWith(weekRefreshStatus: RefreshStatus.idle);
  } else if (action.type == ListPageType.month_trend) {
    return state.copyWith(monthRefreshStatus: RefreshStatus.idle);
  }
  return state;
}

TrendState _receivedTrends(TrendState state, action) {
  LogUtil.v('_receivedTrends', tag: TAG);
  if (action.type == ListPageType.day_trend) {
    return state.copyWith(
      dayStatus: LoadingStatus.success,
      dayTrends: action.trends,
      dayRefreshStatus: action.refreshStatus,
    );
  } else if (action.type == ListPageType.week_trend) {
    return state.copyWith(
      weekStatus: LoadingStatus.success,
      weekTrends: action.trends,
      weekRefreshStatus: action.refreshStatus,
    );
  } else if (action.type == ListPageType.month_trend) {
    return state.copyWith(
      monthStatus: LoadingStatus.success,
      monthTrends: action.trends,
      monthRefreshStatus: action.refreshStatus,
    );
  }
  return state;
}

TrendState _errorLoadingTrends(TrendState state, action) {
  LogUtil.v('_errorLoadingEvents', tag: TAG);

  if (action.type == ListPageType.day_trend) {
    return state.copyWith(
      dayStatus: LoadingStatus.error,
    );
  } else if (action.type == ListPageType.week_trend) {
    return state.copyWith(
      weekStatus: LoadingStatus.error,
    );
  } else if (action.type == ListPageType.month_trend) {
    return state.copyWith(
      monthStatus: LoadingStatus.error,
    );
  }
  return state;
}
