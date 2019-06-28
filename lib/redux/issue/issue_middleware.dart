import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/issue/issue_actions.dart';
import 'package:open_git/redux/issue/issue_state.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

class IssueMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "IssueMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    LogUtil.v(action, tag: TAG);
    next(action);
    if (action is FetchAction && action.type == ListPageType.issue) {
      _fetchIssues(store, next, 1, RefreshStatus.idle);
    } else if (action is RefreshAction && action.type == ListPageType.issue) {
      RefreshStatus status = action.refreshStatus;
      ListPageType type = action.type;
      if (status == RefreshStatus.refresh) {
        next(ResetPageAction(type));
      } else if (status == RefreshStatus.loading) {
        next(IncreasePageAction(type));
      }
      _fetchIssues(store, next, store.state.homeState.page, status);
    } else if (action is RefreshMenuAction) {
      _fetchIssuesForMenuChange(store, next, 1, RefreshStatus.idle, action);
    }
  }

  Future<void> _fetchIssues(Store<AppState> store, NextDispatcher next,
      int page, RefreshStatus status) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<IssueBean> issues = store.state.issueState.issues;

    if (status == RefreshStatus.idle) {
      next(RequestingIssuesAction());
    }

    IssueState state = store.state.issueState;

    try {
      final list = await IssueManager.instance.getIssue(
          state.q, state.state, state.sort, state.order, userName, page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        issues.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        issues.addAll(list);
      }
      next(ReceivedIssuesAction(issues, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingIssuesAction());
    }
  }

  Future<void> _fetchIssuesForMenuChange(
      Store<AppState> store,
      NextDispatcher next,
      int page,
      RefreshStatus status,
      RefreshMenuAction action) async {
    String userName = "";
    if (store.state.userState.currentUser != null) {
      userName = store.state.userState.currentUser.login;
    }

    List<IssueBean> issues = store.state.issueState.issues;

    if (status == RefreshStatus.idle) {
      next(RequestingIssuesAction());
    }

    try {
      final list = await IssueManager.instance.getIssue(
          action.q, action.state, action.sort, action.order, userName, page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        issues.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        issues.addAll(list);
      }
      next(ReceivedIssuesAction(issues, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingIssuesAction());
    }
  }
}
