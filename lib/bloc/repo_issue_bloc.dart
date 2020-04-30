import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';

class RepoIssueBloc extends BaseListBloc<IssueBean> {
  static final String TAG = "RepoIssueBloc";

  final String owner, repo;

  RepoIssueBloc(this.owner, this.repo);

  @override
  void initData(BuildContext context) {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchIssueList();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchIssueList();
  }

  Future _fetchIssueList() async {
    LogUtil.v('_fetchIssueList', tag: TAG);
    try {
      var result = await IssueManager.instance.getRepoIssues(owner, repo, page);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        bean.isError = false;
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      } else {
        if (bean.data.length > 0) {
          bean.isError = false;
          noMore = false;
        } else {
          bean.isError = true;
        }
        if (page > 1) {
          page--;
        }
      }
    } catch (_) {
      if (page > 1) {
        page--;
      }
    }
  }
}
