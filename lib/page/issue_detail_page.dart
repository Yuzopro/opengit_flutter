import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/issue_detail_contract.dart';
import 'package:open_git/presenter/issue_detail_presenter.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class IssueDetailPage extends StatefulWidget {
  final IssueBean issueBean;

  IssueDetailPage(this.issueBean);

  @override
  State<StatefulWidget> createState() {
    return _IssueDetailState(issueBean);
  }
}

class _IssueDetailState extends PullRefreshListState<IssueBean,
    IssueDetailPresenter, IIssueDetailView> implements IIssueDetailView {
  final IssueBean issueBean;

  _IssueDetailState(this.issueBean);

  @override
  String getTitle() {
    if (presenter != null) {
      return "${presenter.getReposFullName(issueBean.repoUrl)} # ${issueBean.number}";
    }
    return "";
  }

  @override
  Widget getItemRow(IssueBean item) {
    return new Center(
      child: Text(item.body),
    );
  }

  @override
  IssueDetailPresenter initPresenter() {
    return new IssueDetailPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      presenter.getIssueComment(
          issueBean.repoUrl, issueBean.number, page, false);
    }
  }
}
