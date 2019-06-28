import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/about/timeline_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class TimelineMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "EventMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchAction && action.type == ListPageType.timeline) {
      _fetchTimelines(store, next, 1, RefreshStatus.idle);
    } else if (action is RefreshAction &&
        action.type == ListPageType.timeline) {
      _handleRefreshAction(store, action, next);
    }
  }

  //处理列表页面下拉和加载更多
  void _handleRefreshAction(
      Store<AppState> store, action, NextDispatcher next) {
    RefreshStatus status = action.refreshStatus;
    ListPageType type = action.type;
    LogUtil.v(
        '_handleRefreshAction status is ' +
            status.toString() +
            "@type is " +
            type.toString(),
        tag: TAG);
    if (status == RefreshStatus.refresh) {
      next(ResetPageAction(type));
    } else if (status == RefreshStatus.loading) {
      next(IncreasePageAction(type));
    }
    _fetchTimelines(store, next, store.state.eventState.page, status);
  }

  Future<void> _fetchTimelines(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status) async {
    List<ReleaseBean> timelines = store.state.timelineState.releases;

    if (status == RefreshStatus.idle) {
      next(RequestingTimelinesAction());
    }
    try {
      final list = await ReposManager.instance
          .getReposReleases('Yuzopro', 'OpenGit_Flutter', page: page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        timelines.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        timelines.addAll(list);
      }
      next(ReceivedTimelinesAction(timelines, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingTimelinesAction());
    }
  }
}
