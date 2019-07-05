import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/status/status.dart';

class ReposDetailBean {
  Repository repos;
  String readme;
  ReposStatus starStatus;
  ReposStatus watchStatus;
  List<BranchBean> branchs;

  ReposDetailBean(
      {this.repos,
      this.readme,
      this.starStatus,
      this.watchStatus,
      this.branchs});
}
