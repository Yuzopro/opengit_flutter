import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/delete_reaction_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class DeleteReactionPresenter extends IDeleteReactionPresenter {
  @override
  deleteReactions(IssueBean item, reaction_id, content) async {
    if (view != null) {
      view.showLoading();
    }
    final response = await IssueManager.instance.deleteReactions(reaction_id);
    if (response != null && response.result) {
      if (view != null) {
        view.onEditSuccess(refreshIssueBean(item, content));
      }
    }
    if (view != null) {
      view.hideLoading();
    }
    return response;
  }

  @override
  getCommentReactions(
      repoUrl, commentId, content, page, isIssue, isFromMore) async {
    final response = await IssueManager.instance
        .getCommentReactions(repoUrl, commentId, content, page, isIssue);
    if (response != null && view != null) {
        view.setList(response, isFromMore);
    }
    return response;
  }

  IssueBean refreshIssueBean(IssueBean issueBean, String comment) {
    if ("+1" == comment) {
      issueBean.reaction.like--;
    } else if ("-1" == comment) {
      issueBean.reaction.noLike--;
    } else if ("hooray" == comment) {
      issueBean.reaction.hooray--;
    } else if ("eyes" == comment) {
      issueBean.reaction.eyes--;
    } else if ("laugh" == comment) {
      issueBean.reaction.laugh--;
    } else if ("confused" == comment) {
      issueBean.reaction.confused--;
    } else if ("rocket" == comment) {
      issueBean.reaction.rocket--;
    } else if ("heart" == comment) {
      issueBean.reaction.heart--;
    }
    return issueBean;
  }
}
