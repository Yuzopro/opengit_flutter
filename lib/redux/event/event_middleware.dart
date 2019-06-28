import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/event_manager.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class EventMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "EventMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchAction && action.type == ListPageType.event) {
      _fetchEvents(store, next, 1, RefreshStatus.idle);
    } else if (action is RefreshEventAction) {
      _handleRefreshAction(store, action, next);
    } else if (action is FetchReposEventAction) {
      _fetchReposEvents(store, next, 1, RefreshStatus.idle, action.reposOwner,
          action.reposName);
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
    if (type == ListPageType.event) {
      _fetchEvents(store, next, store.state.eventState.page, status);
    } else if (type == ListPageType.repos_event) {
      _fetchReposEvents(store, next, store.state.eventState.page_repos, status,
          action.reposOwner, action.reposName);
    }
  }

  Future<void> _fetchEvents(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<EventBean> events = store.state.eventState.events;

    if (status == RefreshStatus.idle) {
      next(RequestingEventsAction(ListPageType.event));
    }
    try {
      final list = await EventManager.instance.getEventReceived(userName, page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        events.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        events.addAll(list);
      }
      next(ReceivedEventsAction(events, newStatus, ListPageType.event));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingEventsAction(ListPageType.event));
    }
  }

  Future<void> _fetchReposEvents(
      Store<AppState> store,
      NextDispatcher next,
      int page,
      RefreshStatus status,
      String reposOwner,
      String reposName) async {
    List<EventBean> events = store.state.eventState.events_repos;

    if (status == RefreshStatus.idle) {
      next(RequestingEventsAction(ListPageType.repos_event));
    }
    try {
      final list = await ReposManager.instance
          .getReposEvents(reposOwner, reposName, page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        events.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        events.addAll(list);
      }
      next(ReceivedEventsAction(events, newStatus, ListPageType.repos_event));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingEventsAction(ListPageType.repos_event));
    }
  }
}
