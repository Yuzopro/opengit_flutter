import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/contract/delete_reaction_contract.dart';
import 'package:open_git/manager/issue_manager.dart';

class DeleteReactionPresenter extends IDeleteReactionPresenter {
  @override
  deleteReactions(IssueBean item, reaction_id, content) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance.deleteReactions(reaction_id, (data) {
      if (view != null) {
        view.onEditSuccess(refreshIssueBean(item, content));
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  @override
  getCommentReactions(repoUrl, commentId, content, page, isIssue, isFromMore) {
    return IssueManager.instance.getCommentReactions(
        repoUrl, commentId, content, page, isIssue, (data) {
      if (data != null && data.length > 0) {
        List<ReactionDetailBean> list = new List();
        int length = data.length;
        for (int i = 0; i < length; i++) {
          list.add(ReactionDetailBean.fromJson(data[i]));
        }
        if (view != null) {
          view.setList(list, isFromMore);
        }
      }
    }, (code, msg) {});
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
