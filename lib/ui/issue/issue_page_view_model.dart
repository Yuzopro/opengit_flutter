import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/issue/issue_actions.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

typedef IssueMenuSelected = void Function(int index, String value);

class IssuePageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<IssueBean> events;
  final String q, state, sort, order;
  final Function onRefresh;
  final Function onLoad;
  final IssueMenuSelected onSelected;

  IssuePageViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.events,
      @required this.onRefresh,
      @required this.onLoad,
      this.q,
      this.state,
      this.sort,
      this.order,
      this.onSelected});

  static IssuePageViewModel fromStore(Store<AppState> store) {
    return IssuePageViewModel(
        status: store.state.issueState.status,
        refreshStatus: store.state.issueState.refreshStatus,
        events: store.state.issueState.issues,
        q: store.state.issueState.q,
        state: store.state.issueState.state,
        sort: store.state.issueState.sort,
        order: store.state.issueState.order,
        onRefresh: () {
          store.dispatch(
              RefreshAction(RefreshStatus.refresh, ListPageType.issue));
        },
        onLoad: () {
          store.dispatch(
              RefreshAction(RefreshStatus.loading, ListPageType.issue));
        },
        onSelected: (type, value) {
          if (type == 0) {
            store.dispatch(RefreshMenuAction(
                value,
                store.state.issueState.state,
                store.state.issueState.sort,
                store.state.issueState.order));
          } else if (type == 1) {
            store.dispatch(RefreshMenuAction(store.state.issueState.q, value,
                store.state.issueState.sort, store.state.issueState.order));
          } else if (type == 2) {
            store.dispatch(RefreshMenuAction(
                store.state.issueState.q,
                store.state.issueState.state,
                value,
                store.state.issueState.order));
          } else if (type == 3) {
            store.dispatch(RefreshMenuAction(
                store.state.issueState.q,
                store.state.issueState.state,
                store.state.issueState.sort,
                value));
          }
        });
  }
}
