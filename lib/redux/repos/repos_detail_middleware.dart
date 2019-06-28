import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_detail_action.dart';
import 'package:open_git/ui/repos/repos_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class ReposDetailMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposDetailMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchReposDetailAction) {
      _fetchReposDetails(store, next, action.refreshStatus, action.reposOwner,
          action.reposName);
    } else if (action is FetchReposReadmeAction) {
      _fetchReadme(next, action.reposOwner, action.reposName);
    } else if (action is ChangeReposStarStatusAction) {
      _doStarStatus(store, next, action.reposOwner, action.reposName);
    } else if (action is ChangeReposWatchStatusAction) {
      _doWatchStatus(store, next, action.reposOwner, action.reposName);
    } else if (action is FetchReposBranchsAction) {
      _fetchBranchs(next, action.reposOwner, action.reposName);
    }
  }

  Future<void> _fetchReposDetails(Store<AppState> store, NextDispatcher next,
      RefreshStatus status, String reposOwner, String reposName) async {
    if (status == RefreshStatus.idle) {
      next(RequestingReposDetailAction());
    }
    try {
      final repos =
          await ReposManager.instance.getReposDetail(reposOwner, reposName);
      RefreshStatus newStatus = status;
      if (repos != null) {
        if (status == RefreshStatus.refresh) {
          newStatus = RefreshStatus.refresh_no_data;
        } else {
          newStatus = RefreshStatus.loading_no_data;
        }
      }
      next(ReceivedReposDetailAction(repos, newStatus));
      _fetchStarStatus(next, reposOwner, reposName);
      _fetchWatchStatus(next, reposOwner, reposName);
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingReposDetailAction());
    }
  }

  Future<void> _fetchStarStatus(
      NextDispatcher next, String reposOwner, String reposName) async {
    final response =
        await ReposManager.instance.getReposStar(reposOwner, reposName);
    next(ReceivedStarStatusAction(
        response.result ? ReposStatus.active : ReposStatus.inactive));
  }

  Future<void> _fetchWatchStatus(
      NextDispatcher next, String reposOwner, String reposName) async {
    final response =
        await ReposManager.instance.getReposWatcher(reposOwner, reposName);
    next(ReceivedWatchStatusAction(
        response.result ? ReposStatus.active : ReposStatus.inactive));
  }

  Future<void> _fetchReadme(
      NextDispatcher next, String reposOwner, String reposName) async {
    final response =
        await ReposManager.instance.getReadme("$reposOwner/$reposName", null);
    next(ReceivedReadmeAction(response));
  }

  Future<void> _fetchBranchs(
      NextDispatcher next, String reposOwner, String reposName) async {
    final response =
        await ReposManager.instance.getBranches(reposOwner, reposName);
    next(ReceivedBranchsAction(response));
  }

  Future<void> _doStarStatus(Store<AppState> store, NextDispatcher next,
      String reposOwner, String reposName) async {
    bool isEnable =
        store.state.reposDetailState.starStatus == ReposStatus.active;
    final response = await ReposManager.instance
        .doReposStarAction(reposOwner, reposName, isEnable);
    ReposStatus newStatus = store.state.reposDetailState.starStatus;
    if (response.result) {
      if (isEnable) {
        newStatus = ReposStatus.inactive;
      } else {
        newStatus = ReposStatus.active;
      }
    }
    next(ReceivedStarStatusAction(newStatus));
  }

  Future<void> _doWatchStatus(Store<AppState> store, NextDispatcher next,
      String reposOwner, String reposName) async {
    bool isEnable =
        store.state.reposDetailState.watchStatus == ReposStatus.active;
    final response = await ReposManager.instance
        .doRepossWatcherAction(reposOwner, reposName, isEnable);
    ReposStatus newStatus = store.state.reposDetailState.watchStatus;
    if (response.result) {
      if (isEnable) {
        newStatus = ReposStatus.inactive;
      } else {
        newStatus = ReposStatus.active;
      }
    }
    next(ReceivedWatchStatusAction(newStatus));
  }
}
