import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/manager/event_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class EventMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "EventMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchAction && action.type == ListPageType.event) {
      _fetchEvents(store, next, 1, RefreshStatus.idle);
    } else if (action is RefreshAction && action.type == ListPageType.event) {
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
    _fetchEvents(store, next, store.state.eventState.page, status);
  }

  Future<void> _fetchEvents(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<EventBean> events = store.state.eventState.events;

    if (status == RefreshStatus.idle) {
      next(RequestingEventsAction());
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
      next(ReceivedEventsAction(events, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingEventsAction());
    }
  }
}
