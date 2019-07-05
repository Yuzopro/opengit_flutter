import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/mvp/contract/issue_detail_contract.dart';

class IssueDetailPresenter extends IIssueDetailPresenter {
  @override
  getSingleIssue(repoUrl, number) {
    return IssueManager.instance.getSingleIssue(repoUrl, number);
  }

  @override
  getIssueComment(repoUrl, issueNumber, page, isFromMore) async {
    IssueBean issueBean;
    if (!isFromMore) {
      issueBean = await getSingleIssue(repoUrl, issueNumber);
    }
    final response =
        await IssueManager.instance.getIssueComment(repoUrl, issueNumber, page);
    if (response != null && view != null) {
      view.onGetSingleIssueSuccess(issueBean);
      view.setList(response, isFromMore);
    }
  }

  @override
  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("/") + 1)
        : "";
  }

  @override
  String getRepoAuthorName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(
            repoUrl.lastIndexOf("repos/") + 6, repoUrl.lastIndexOf("/"))
        : null;
  }

  @override
  editReactions(IssueBean item, repoUrl, comment, isIssue) async {
    if (view != null) {
      view.showLoading();
    }
    await _queryIssueCommentReaction(item, repoUrl, comment, isIssue);
    if (view != null) {
      view.hideLoading();
    }
  }

  @override
  bool isEditAndDeleteEnable(IssueBean issueBean, IssueBean item) {
    if (item == null ||
        item.user == null ||
        item.user.login == null ||
        issueBean == null ||
        issueBean.user == null ||
        issueBean.user.login == null) {
      return false;
    }
    UserBean userBean = LoginManager.instance.getUserBean();
    String authorName = getRepoAuthorName(issueBean.repoUrl);
    if (userBean != null && userBean.login == authorName) {
      return true;
    }
    if (userBean != null && userBean.login == issueBean.user.login) {
      return true;
    }
    if (userBean != null && userBean.login == item.user.login) {
      return true;
    }
    return false;
  }

  _queryIssueCommentReaction(
      IssueBean issueBean, repoUrl, comment, isIssue) async {
    int id;
    if (isIssue) {
      id = issueBean.number;
    } else {
      id = issueBean.id;
    }
    final response = await IssueManager.instance
        .getCommentReactions(repoUrl, id, comment, 1, isIssue);
    ReactionDetailBean findReaction = null;
    if (response != null) {
      UserBean userBean = LoginManager.instance.getUserBean();
      for (int i = 0; i < response.length; i++) {
        ReactionDetailBean reactionDetailBean = response[i];
        if (reactionDetailBean != null &&
            reactionDetailBean.content == comment &&
            userBean != null &&
            reactionDetailBean.user != null &&
            userBean.login == reactionDetailBean.user.login) {
          findReaction = reactionDetailBean;
          break;
        }
      }
    }
    if (findReaction != null) {
      return await _deleteIssueCommentReaction(
          issueBean, findReaction, comment);
    } else {
      return await _createIssueCommentReaction(
          issueBean, repoUrl, comment, isIssue);
    }
  }

  _createIssueCommentReaction(IssueBean item, repoUrl, comment, isIssue) async {
    int id;
    if (isIssue) {
      id = item.number;
    } else {
      id = item.id;
    }
    final response = await IssueManager.instance
        .editReactions(repoUrl, id, comment, isIssue);
    if (response != null && response.result) {
      if (view != null) {
        view.onEditSuccess(_addIssueBean(item, comment));
      }
    }
    if (view != null) {
      view.hideLoading();
    }
    return response;
  }

  _deleteIssueCommentReaction(
      IssueBean issueBean, ReactionDetailBean item, content) async {
    final response = await IssueManager.instance.deleteReactions(item.id);
    if (response != null && response.result) {
      if (view != null) {
        view.onEditSuccess(_subtractionIssueBean(issueBean, content));
      }
    }
    if (view != null) {
      view.hideLoading();
    }
    return response;
  }

  @override
  deleteIssueComment(IssueBean issueBean, repoUrl, comment_id) async {
    if (view != null) {
      view.showLoading();
    }
    final response =
        await IssueManager.instance.deleteIssueComment(repoUrl, comment_id);
    if (response != null && response.result) {
      if (view != null) {
        view.onDeleteSuccess(issueBean);
      }
    }
    if (view != null) {
      view.hideLoading();
    }
    return response;
  }

  IssueBean _subtractionIssueBean(IssueBean issueBean, String comment) {
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

  IssueBean _addIssueBean(IssueBean issueBean, String comment) {
    if ("+1" == comment) {
      issueBean.reaction.like++;
    } else if ("-1" == comment) {
      issueBean.reaction.noLike++;
    } else if ("hooray" == comment) {
      issueBean.reaction.hooray++;
    } else if ("eyes" == comment) {
      issueBean.reaction.eyes++;
    } else if ("laugh" == comment) {
      issueBean.reaction.laugh++;
    } else if ("confused" == comment) {
      issueBean.reaction.confused++;
    } else if ("rocket" == comment) {
      issueBean.reaction.rocket++;
    } else if ("heart" == comment) {
      issueBean.reaction.heart++;
    }
    return issueBean;
  }
}
