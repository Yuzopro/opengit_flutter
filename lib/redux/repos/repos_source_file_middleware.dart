import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_source_file_actions.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class ReposSourceFileMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposSourceFileMiddleware";

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is FetchReposFileAction) {
      _fetchReposFiles(store, next, action.refreshStatus, action.reposOwner,
          action.reposName);
    } else if (action is FetchNextAction) {
      next(PushFileAction(action.fileName));
      _fetchReposFiles(
          store, next, RefreshStatus.idle, action.reposOwner, action.reposName);
    } else if (action is FetchPreAction) {
      next(PopFileAction());
      _fetchReposFiles(
          store, next, RefreshStatus.idle, action.reposOwner, action.reposName);
    }
  }

  Future<void> _fetchReposFiles(Store<AppState> store, NextDispatcher next,
      RefreshStatus status, String reposOwner, String reposName) async {
    if (status == RefreshStatus.idle) {
      next(RequestingFilesAction());
    }
    String path =
        _getHeaderPath(store.state.reposSourceFileState.fileStack, reposName);
    try {
      final repos = await ReposManager.instance
          .getReposFileDir(reposOwner, reposName, path: path);
      RefreshStatus newStatus = status;
      if (repos != null) {
        if (status == RefreshStatus.refresh) {
          newStatus = RefreshStatus.refresh_no_data;
        }
      }
      next(ReceivedFilesAction(repos, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingFilesAction());
    }
  }

  String _getHeaderPath(List<String> stack, String reposName) {
    int length = stack.length;
    String path = "";
    for (int i = 0; i < length; i++) {
      path += ("/" + stack[i]);
    }
    return path;
  }
}
