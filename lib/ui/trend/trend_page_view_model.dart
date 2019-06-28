import 'package:flutter/widgets.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/trend/trend_actions.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class TrendPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<TrendBean> trends;
  final Function onRefresh;

  TrendPageViewModel({
    @required this.status,
    @required this.refreshStatus,
    @required this.trends,
    @required this.onRefresh,
  });

  static TrendPageViewModel fromStore(
    Store<AppState> store,
    ListPageType type,
    String since,
    String trend,
  ) {
    return TrendPageViewModel(
        status: getStatus(store, type),
        trends: getTrends(store, type),
        refreshStatus: getRefreshStatus(store, type),
        onRefresh: () {
          store.dispatch(
              RefreshTrendsAction(RefreshStatus.refresh, type, since, trend));
        });
  }

  static LoadingStatus getStatus(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.day_trend) {
      return store.state.trendState.dayStatus;
    } else if (type == ListPageType.week_trend) {
      return store.state.trendState.weekStatus;
    } else if (type == ListPageType.month_trend) {
      return store.state.trendState.monthStatus;
    }
    return null;
  }

  static RefreshStatus getRefreshStatus(
      Store<AppState> store, ListPageType type) {
    if (type == ListPageType.day_trend) {
      return store.state.trendState.dayRefreshStatus;
    } else if (type == ListPageType.week_trend) {
      return store.state.trendState.weekRefreshStatus;
    } else if (type == ListPageType.month_trend) {
      return store.state.trendState.monthRefreshStatus;
    }
    return null;
  }

  static List<TrendBean> getTrends(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.day_trend) {
      return store.state.trendState.dayTrends;
    } else if (type == ListPageType.week_trend) {
      return store.state.trendState.weekTrends;
    } else if (type == ListPageType.month_trend) {
      return store.state.trendState.monthTrends;
    }
    return [];
  }
}
