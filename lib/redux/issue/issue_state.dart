import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/refresh_status.dart';

class IssueState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<IssueBean> issues;
  final int page;
  final String q, state, sort, order;

  IssueState({
    this.status,
    this.refreshStatus,
    this.issues,
    this.page,
    this.q,
    this.state,
    this.sort,
    this.order,
  });

  factory IssueState.initial() {
    return IssueState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      issues: [],
      page: 1,
      q: "involves",
      state: "open",
      sort: "created",
      order: "asc",
    );
  }

  IssueState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<IssueBean> issues,
      int page,
      String q,
      String state,
      String sort,
      String order}) {
    return IssueState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      issues: issues ?? this.issues,
      page: page ?? this.page,
      q: q ?? this.q,
      state: state ?? this.state,
      sort: sort ?? this.sort,
      order: order ?? this.order,
    );
  }

  @override
  String toString() {
    return 'IssueState{page: $page}';
  }
}
