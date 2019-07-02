import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/repos/repos_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class ReposMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchReposAction) {
      _fetchRepos(store, next, 1, RefreshStatus.idle, action.type, action.userName);
    } else if (action is RefreshReposAction) {
      RefreshStatus status = action.refreshStatus;
      if (status == RefreshStatus.refresh) {
        next(ResetPageAction(action.type));
      } else if (status == RefreshStatus.loading) {
        next(IncreasePageAction(action.type));
      }
      if (action.type == ListPageType.repos_trend) {
        _fetchReposTrend(store, next, store.state.reposState.page_trend, status,
            action.language);
      } else {
        _fetchRepos(
            store, next, store.state.reposState.page, status, action.type, action.userName);
      }
    }
    if (action is FetchReposTrendAction) {
      _fetchReposTrend(store, next, 1, RefreshStatus.idle, action.language);
    }
  }

  Future<void> _fetchRepos(Store<AppState> store, NextDispatcher next, int page,
      RefreshStatus status, ListPageType type, String userName) async {
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

  Future<void> _fetchReposTrend(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status, String language) async {
    List<Repository> repos = store.state.reposState.repos_trend;

    if (status == RefreshStatus.idle) {
      next(RequestingReposAction(ListPageType.repos_trend));
    }
    try {
      final list = await ReposManager.instance.getLanguages(language, page);
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
      LogUtil.v('_fetchReposTrend newStatus is ' + newStatus.toString());
      next(ReceivedReposAction(repos, newStatus, ListPageType.repos_trend));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingReposAction(ListPageType.repos_trend));
    }
  }
}
