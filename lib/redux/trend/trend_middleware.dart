import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/trend/trend_actions.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class TrendMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "TrendMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchTrendsAction &&
        (action.type == ListPageType.day_trend ||
            action.type == ListPageType.week_trend ||
            action.type == ListPageType.month_trend)) {
      _fetchTrends(store, next, RefreshStatus.idle, action.type, action.since,
          action.trend);
    } else if (action is RefreshTrendsAction &&
        (action.type == ListPageType.day_trend ||
            action.type == ListPageType.week_trend ||
            action.type == ListPageType.month_trend)) {
      _fetchTrends(store, next, action.refreshStatus, action.type, action.since,
          action.trend);
    }
  }

  Future<void> _fetchTrends(
      Store<AppState> store,
      NextDispatcher next,
      RefreshStatus status,
      ListPageType type,
      String since,
      String trend) async {
    List<TrendBean> trends = getTrends(store, type);

    if (status == RefreshStatus.idle) {
      next(RequestingTrendsAction(type));
    }
    try {
      final list = await ReposManager.instance.getTrend(since, trend);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        trends.clear();
      }
      if (list != null && list.length > 0) {
        if (status == RefreshStatus.refresh) {
          newStatus = RefreshStatus.refresh_no_data;
        } else {
          newStatus = RefreshStatus.loading_no_data;
        }
        trends.addAll(list);
      }
      next(ReceivedTrendsAction(trends, newStatus, type));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingTrendsAction(type));
    }
  }

  List<TrendBean> getTrends(Store<AppState> store, ListPageType type) {
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
