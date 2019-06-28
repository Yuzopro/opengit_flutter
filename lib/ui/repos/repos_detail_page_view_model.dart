import 'package:flutter/widgets.dart';
import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_detail_action.dart';
import 'package:open_git/ui/repos/repos_status.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class ReposDetailPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final Repository repos;
  final String readme;
  final ReposStatus starStatus;
  final ReposStatus watchStatus;
  final List<BranchBean> branchs;
  final Function onRefresh;
  final ValueChanged<bool> onLoadReadme;
  final VoidCallback onStarClick;
  final VoidCallback onWatchClick;
  final ValueChanged<bool> onLoadBranch;

  ReposDetailPageViewModel(
      {this.status,
      this.refreshStatus,
      this.repos,
      this.readme,
      this.starStatus,
      this.watchStatus,
      this.branchs,
      this.onRefresh,
      this.onLoadReadme,
      this.onStarClick,
      this.onWatchClick,
      this.onLoadBranch});

  static ReposDetailPageViewModel fromStore(
      Store<AppState> store, String reposOwner, String reposName) {
    return ReposDetailPageViewModel(
      status: store.state.reposDetailState.status,
      refreshStatus: store.state.reposDetailState.refreshStatus,
      repos: store.state.reposDetailState.repos,
      readme: store.state.reposDetailState.readme,
      starStatus: store.state.reposDetailState.starStatus,
      watchStatus: store.state.reposDetailState.watchStatus,
      branchs: store.state.reposDetailState.branchs,
      onRefresh: () {
        store.dispatch(FetchReposDetailAction(
            reposOwner, reposName, RefreshStatus.refresh));
      },
      onLoadReadme: (isExpand) {
        store.dispatch(FetchReposReadmeAction(reposOwner, reposName));
      },
      onLoadBranch: (isExpand) {
        store.dispatch(FetchReposBranchsAction(reposOwner, reposName));
      },
      onStarClick: () {
        store.dispatch(ChangeReposStarStatusAction(reposOwner, reposName));
      },
      onWatchClick: () {
        store.dispatch(ChangeReposWatchStatusAction(reposOwner, reposName));
      },
    );
  }
}
