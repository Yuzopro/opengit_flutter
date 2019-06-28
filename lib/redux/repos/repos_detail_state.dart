import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/ui/repos/repos_status.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class ReposDetailState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final Repository repos;
  final String readme;
  final ReposStatus starStatus;
  final ReposStatus watchStatus;
  final List<BranchBean> branchs;

  ReposDetailState(
      {this.status,
      this.refreshStatus,
      this.repos,
      this.readme,
      this.starStatus,
      this.watchStatus,
      this.branchs});

  factory ReposDetailState.initial() {
    return ReposDetailState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      repos: null,
      readme: '',
      starStatus: ReposStatus.idle,
      watchStatus: ReposStatus.idle,
      branchs: [],
    );
  }

  ReposDetailState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      Repository repos,
      String readme,
      String owner,
      String name,
      ReposStatus starStatus,
      ReposStatus watchStatus,
      List<BranchBean> branchs}) {
    return ReposDetailState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      repos: repos ?? this.repos,
      readme: readme ?? this.readme,
      starStatus: starStatus ?? this.starStatus,
      watchStatus: watchStatus ?? this.watchStatus,
      branchs: branchs ?? this.branchs,
    );
  }
}
