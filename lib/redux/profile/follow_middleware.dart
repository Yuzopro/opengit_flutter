import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/profile/follow_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class FollowMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchFollowsAction) {
      _fetchFollows(store, next, 1, RefreshStatus.idle, action.type);
    } else if (action is RefreshFollowsAction) {
      RefreshStatus status = action.refreshStatus;
      if (status == RefreshStatus.refresh) {
        next(ResetPageAction(action.type));
      } else if (status == RefreshStatus.loading) {
        next(IncreasePageAction(action.type));
      }
      _fetchFollows(
          store, next, store.state.reposState.page, status, action.type);
    }
  }

  Future<void> _fetchFollows(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status, ListPageType type) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<UserBean> users = getList(store, type);

    if (status == RefreshStatus.idle) {
      next(RequestingFollowsAction(type));
    }
    try {
      var list;
      if (type == ListPageType.follower) {
        list = await UserManager.instance.getUserFollowing(userName, page);
      } else {
        list = await UserManager.instance.getUserFollower(userName, page);
      }
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        users.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        users.addAll(list);
      }
      LogUtil.v('_fetchRepos newStatus is ' + newStatus.toString());
      next(ReceivedFollowsAction(users, newStatus, type));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingFollowsAction(type));
    }
  }

  List<UserBean> getList(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.follower) {
      return store.state.followState.user_follow;
    } else if (type == ListPageType.by_follower) {
      return store.state.followState.user_by_follow;
    }
    return [];
  }
}
