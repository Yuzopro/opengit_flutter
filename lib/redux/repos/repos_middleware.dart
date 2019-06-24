import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/repos/repos_actions.dart';
import 'package:open_git/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class ReposMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchReposAction) {
      _fetchRepos(store, next, 1, RefreshStatus.idle, action.type);
    } else if (action is RefreshReposAction) {
      RefreshStatus status = action.refreshStatus;
      if (status == RefreshStatus.refresh) {
        next(ResetPageAction(ListPageType.repos));
      } else if (status == RefreshStatus.loading) {
        next(IncreasePageAction(ListPageType.repos));
      }
      _fetchRepos(
          store, next, store.state.reposState.page, status, action.type);
    }
  }

  Future<void> _fetchRepos(Store<AppState> store, NextDispatcher next, int page,
      RefreshStatus status, ListPageType type) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<Repository> repos = getList(store, type);

    if (status == RefreshStatus.idle) {
      next(RequestingReposAction(type));
    }
    try {
      final list = await UserManager.instance.getUserRepos(
          userName, page, null, type == ListPageType.repos_user_star);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        repos.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        repos.addAll(list);
      }
      LogUtil.v('_fetchRepos newStatus is ' + newStatus.toString());
      next(ReceivedReposAction(repos, newStatus, type));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingReposAction(type));
    }
  }

  List<Repository> getList(Store<AppState> store, ListPageType type) {
    if (type == ListPageType.repos) {
      return store.state.reposState.repos;
    } else if (type == ListPageType.repos_user) {
      return store.state.reposState.repos_user;
    } else if (type == ListPageType.repos_user_star) {
      return store.state.reposState.repos_user_star;
    }
    return [];
  }
}
