import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/ui/repos/repos_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class FetchReposDetailAction {
  final String reposOwner;
  final String reposName;
  final RefreshStatus refreshStatus;

  FetchReposDetailAction(this.reposOwner, this.reposName, this.refreshStatus);
}

class FetchReposReadmeAction {
  final String reposOwner;
  final String reposName;

  FetchReposReadmeAction(this.reposOwner, this.reposName);
}

class ChangeReposStarStatusAction {
  final String reposOwner;
  final String reposName;

  ChangeReposStarStatusAction(this.reposOwner, this.reposName);
}

class ChangeReposWatchStatusAction {
  final String reposOwner;
  final String reposName;

  ChangeReposWatchStatusAction(this.reposOwner, this.reposName);
}

class FetchReposBranchsAction {
  final String reposOwner;
  final String reposName;

  FetchReposBranchsAction(this.reposOwner, this.reposName);
}

class RequestingReposDetailAction {}

class ReceivedReposDetailAction {
  final Repository repos;
  final RefreshStatus refreshStatus;

  ReceivedReposDetailAction(this.repos, this.refreshStatus);
}

class ReceivedStarStatusAction {
  final ReposStatus starStatus;

  ReceivedStarStatusAction(this.starStatus);
}

class ReceivedWatchStatusAction {
  final ReposStatus watchStatus;

  ReceivedWatchStatusAction(this.watchStatus);
}

class ReceivedReadmeAction {
  final String readme;

  ReceivedReadmeAction(this.readme);
}

class ReceivedBranchsAction {
  final List<BranchBean> branchs;

  ReceivedBranchsAction(this.branchs);
}

class ErrorLoadingReposDetailAction {}
