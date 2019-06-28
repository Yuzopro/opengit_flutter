import 'package:flutter/widgets.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/profile/follow_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class FollowPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<UserBean> users;
  final Function onRefresh;
  final Function onLoad;

  FollowPageViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.users,
      @required this.onRefresh,
      @required this.onLoad});

  static FollowPageViewModel fromStore(
      Store<AppState> store, ListPageType type) {
    return FollowPageViewModel(
        status: getLoadingStatus(store, type),
        refreshStatus: getRefreshStatus(store, type),
        users: getList(store, type),
        onRefresh: () {
          store.dispatch(RefreshFollowsAction(RefreshStatus.refresh, type));
        },
        onLoad: () {
          store.dispatch(RefreshFollowsAction(RefreshStatus.loading, type));
        });
  }

  static LoadingStatus getLoadingStatus(
      Store<AppState> store, ListPageType type) {
    if (type == ListPageType.follower) {
      return store.state.followState.status_follow;
    } else if (type == ListPageType.by_follower) {
      return store.state.followState.status_by_follow;
    }
    return null;
  }

  static RefreshStatus getRefreshStatus(
      Store<AppState> store, ListPageType type) {
    if (type == ListPageType.follower) {
      return store.state.followState.refreshStatus_follow;
    } else if (type == ListPageType.by_follower) {
      return store.state.followState.refreshStatus_by_follow;
    }
    return null;
  }

  static List<UserBean> getList(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.follower) {
      return store.state.followState.user_follow;
    } else if (type == ListPageType.by_follower) {
      return store.state.followState.user_by_follow;
    }
    return null;
  }
}
