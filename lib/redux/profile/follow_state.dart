import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class FollowState {
  final LoadingStatus status_follow;
  final RefreshStatus refreshStatus_follow;
  final List<UserBean> user_follow;
  final int page_follow;
  final LoadingStatus status_by_follow;
  final RefreshStatus refreshStatus_by_follow;
  final List<UserBean> user_by_follow;
  final int page_by_follow;

  FollowState(
      {this.status_follow,
      this.refreshStatus_follow,
      this.user_follow,
      this.page_follow,
      this.status_by_follow,
      this.refreshStatus_by_follow,
      this.user_by_follow,
      this.page_by_follow});

  factory FollowState.initial() {
    return FollowState(
      status_follow: LoadingStatus.idle,
      refreshStatus_follow: RefreshStatus.idle,
      user_follow: [],
      page_follow: 1,
      status_by_follow: LoadingStatus.idle,
      refreshStatus_by_follow: RefreshStatus.idle,
      user_by_follow: [],
      page_by_follow: 1,
    );
  }

  FollowState copyWith({
    LoadingStatus status_follow,
    RefreshStatus refreshStatus_follow,
    List<UserBean> user_follow,
    int page_follow,
    LoadingStatus status_by_follow,
    RefreshStatus refreshStatus_by_follow,
    List<UserBean> user_by_follow,
    int page_by_follow,
  }) {
    return FollowState(
      status_follow: status_follow ?? this.status_follow,
      refreshStatus_follow: refreshStatus_follow ?? this.refreshStatus_follow,
      user_follow: user_follow ?? this.user_follow,
      page_follow: page_follow ?? this.page_follow,
      status_by_follow: status_by_follow ?? this.status_by_follow,
      refreshStatus_by_follow:
          refreshStatus_by_follow ?? this.refreshStatus_by_follow,
      user_by_follow: user_by_follow ?? this.user_by_follow,
      page_by_follow: page_by_follow ?? this.page_by_follow,
    );
  }
}
