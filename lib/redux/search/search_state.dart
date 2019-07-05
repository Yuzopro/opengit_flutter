import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';

class SearchState {
  final LoadingStatus status_repos;
  final RefreshStatus refreshStatus_repos;
  final List<Repository> repos;
  final int page_repos;

  final LoadingStatus status_user;
  final RefreshStatus refreshStatus_user;
  final List<UserBean> users;
  final int page_user;

  final LoadingStatus status_issue;
  final RefreshStatus refreshStatus_issue;
  final List<IssueBean> issues;
  final int page_issue;

  SearchState(
      {this.status_repos,
      this.refreshStatus_repos,
      this.repos,
      this.page_repos,
      this.status_user,
      this.refreshStatus_user,
      this.users,
      this.page_user,
      this.status_issue,
      this.refreshStatus_issue,
      this.issues,
      this.page_issue});

  factory SearchState.initial() {
    return SearchState(
      status_repos: LoadingStatus.idle,
      refreshStatus_repos: RefreshStatus.idle,
      repos: [],
      page_repos: 1,
      status_user: LoadingStatus.idle,
      refreshStatus_user: RefreshStatus.idle,
      users: [],
      page_user: 1,
      status_issue: LoadingStatus.idle,
      refreshStatus_issue: RefreshStatus.idle,
      issues: [],
      page_issue: 1,
    );
  }

  SearchState copyWith(
      {LoadingStatus status_repos,
        RefreshStatus refreshStatus_repos,
        List<Repository> repos,
        int page_repos,
        LoadingStatus status_user,
        RefreshStatus refreshStatus_user,
        List<UserBean> users,
        int page_user,
        LoadingStatus status_issue,
        RefreshStatus refreshStatus_issue,
        List<UserBean> issues,
        int page_issue,
        }) {
    return SearchState(
      status_user: status_user ?? this.status_user,
      refreshStatus_user: refreshStatus_user ?? this.refreshStatus_user,
      users: users ?? this.users,
      page_user: page_user ?? this.page_user,
      status_repos: status_repos ?? this.status_repos,
      refreshStatus_repos: refreshStatus_repos ?? this.refreshStatus_repos,
      repos: repos ?? this.repos,
      page_repos: page_repos ?? this.page_repos,
      status_issue: status_issue ?? this.status_issue,
      refreshStatus_issue: refreshStatus_issue ?? this.refreshStatus_issue,
      issues: issues ?? this.issues,
      page_issue: page_issue ?? this.page_issue,
    );
  }
}
