import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/refresh_status.dart';

class ReposState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Repository> repos;
  final int page;

  final LoadingStatus status_user;
  final RefreshStatus refreshStatus_user;
  final List<Repository> repos_user;
  final int page_user;

  final LoadingStatus status_user_star;
  final RefreshStatus refreshStatus_user_star;
  final List<Repository> repos_user_star;
  final int page_user_star;

  ReposState(
      {this.status,
      this.refreshStatus,
      this.repos,
      this.page,
      this.status_user,
      this.refreshStatus_user,
      this.repos_user,
      this.page_user,
      this.status_user_star,
      this.refreshStatus_user_star,
      this.repos_user_star,
      this.page_user_star});

  factory ReposState.initial() {
    return ReposState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      repos: [],
      page: 1,
      status_user: LoadingStatus.idle,
      refreshStatus_user: RefreshStatus.idle,
      repos_user: [],
      page_user: 1,
      status_user_star: LoadingStatus.idle,
      refreshStatus_user_star: RefreshStatus.idle,
      repos_user_star: [],
      page_user_star: 1,
    );
  }

  ReposState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<Repository> repos,
      int page,
      LoadingStatus status_user,
      RefreshStatus refreshStatus_user,
      List<Repository> repos_user,
      int page_user,
      LoadingStatus status_user_star,
      RefreshStatus refreshStatus_user_star,
      List<Repository> repos_user_star,
      int page_user_star}) {
    return ReposState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      repos: repos ?? this.repos,
      page: page ?? this.page,
      status_user: status_user ?? this.status_user,
      refreshStatus_user: refreshStatus_user ?? this.refreshStatus_user,
      repos_user: repos_user ?? this.repos_user,
      page_user: page_user ?? this.page_user,
      status_user_star: status_user_star ?? this.status_user_star,
      refreshStatus_user_star:
          refreshStatus_user_star ?? this.refreshStatus_user_star,
      repos_user_star: repos_user_star ?? this.repos_user_star,
      page_user_star: page_user_star ?? this.page_user_star,
    );
  }

  @override
  String toString() {
    return 'ReposState{page: $page}';
  }
}
