import 'package:flutter/widgets.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_actions.dart';
import 'package:open_git/refresh_status.dart';
import 'package:redux/redux.dart';

class ReposPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Repository> repos;
  final Function onRefresh;
  final Function onLoad;

  ReposPageViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.repos,
      @required this.onRefresh,
      @required this.onLoad});

  static ReposPageViewModel fromStore(
      Store<AppState> store, ListPageType type) {
    return ReposPageViewModel(
        status: getLoadingStatus(store, type),
        refreshStatus: getRefreshStatus(store, type),
        repos: getList(store, type),
        onRefresh: () {
          store.dispatch(RefreshReposAction(RefreshStatus.refresh, type));
        },
        onLoad: () {
          store.dispatch(RefreshReposAction(RefreshStatus.loading, type));
        });
  }

  static LoadingStatus getLoadingStatus(
      Store<AppState> store, ListPageType type) {
    if (type == ListPageType.repos) {
      return store.state.reposState.status;
    } else if (type == ListPageType.repos_user) {
      return store.state.reposState.status_user;
    } else if (type == ListPageType.repos_user_star) {
      return store.state.reposState.status_user_star;
    }
    return null;
  }

  static RefreshStatus getRefreshStatus(
      Store<AppState> store, ListPageType type) {
    if (type == ListPageType.repos) {
      return store.state.reposState.refreshStatus;
    } else if (type == ListPageType.repos_user) {
      return store.state.reposState.refreshStatus_user;
    } else if (type == ListPageType.repos_user_star) {
      return store.state.reposState.refreshStatus_user_star;
    }
    return null;
  }

  static List<Repository> getList(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.repos) {
      return store.state.reposState.repos;
    } else if (type == ListPageType.repos_user) {
      return store.state.reposState.repos_user;
    } else if (type == ListPageType.repos_user_star) {
      return store.state.reposState.repos_user_star;
    }
    return null;
  }
}
