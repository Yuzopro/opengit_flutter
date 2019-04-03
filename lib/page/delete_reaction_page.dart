import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/contract/delete_reaction_contract.dart';
import 'package:open_git/presenter/delete_reaction_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class DeleteReactionPage extends StatefulWidget {
  final IssueBean issueBean;
  final String reposUrl, content;
  final bool isIssue;

  DeleteReactionPage(this.issueBean, this.reposUrl, this.content, this.isIssue);

  @override
  State<StatefulWidget> createState() {
    return _DeleteReactionState(issueBean, reposUrl, content, isIssue);
  }
}

class _DeleteReactionState extends PullRefreshListState<
    ReactionDetailBean,
    DeleteReactionPresenter,
    IDeleteReactionView> implements IDeleteReactionView {
  final IssueBean issueBean;
  final String reposUrl, content;
  final bool isIssue;

  _DeleteReactionState(
      this.issueBean, this.reposUrl, this.content, this.isIssue);

  @override
  String getTitle() {
    return content;
  }

  @override
  Widget getItemRow(ReactionDetailBean item) {
    print(item);
    return new ListTile(
      leading: ImageUtil.getImageWidget(item.user.avatarUrl, 36.0),
      title: Text(item.user.login),
      subtitle: Text(item.createdAt),
      onTap: () {
        _deleteReactions(item);
      },
    );
  }

  @override
  DeleteReactionPresenter initPresenter() {
    return new DeleteReactionPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      int id;
      if (isIssue) {
        id = issueBean.number;
      } else {
        id = issueBean.id;
      }
      await presenter.getCommentReactions(
          reposUrl, id, content, page, isIssue, false);
    }
  }

  void _deleteReactions(ReactionDetailBean item) async {
    if (presenter != null) {
      final result =
          await presenter.deleteReactions(issueBean, item.id, content);
      if (result != null) {
        Navigator.pop(context, presenter.refreshIssueBean(issueBean, content));
      }
    }
  }

  @override
  void onEditSuccess(IssueBean issueBean) {
//    Navigator.pop(context, issueBean);
  }
}
