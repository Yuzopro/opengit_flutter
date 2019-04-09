import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/issue_detail_contract.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';

class IssueDetailPresenter extends IIssueDetailPresenter {
  @override
  getSingleIssue(repoUrl, number) {
    return IssueManager.instance.getSingleIssue(repoUrl, number, (data) {
//      if (data != null && view != null) {
//        view.onGetSingleIssueSuccess(IssueBean.fromJson(data));
//      }
    }, (code, msg) {});
  }

  @override
  getIssueComment(repoUrl, issueNumber, page, isFromMore) async {
    IssueBean issueBean;
    if (!isFromMore) {
      var result = await getSingleIssue(repoUrl, issueNumber);
      issueBean = IssueBean.fromJson(result);
    }
    return IssueManager.instance.getIssueComment(repoUrl, issueNumber, page,
        (data) {
      if (data != null && data.length > 0) {
        List<IssueBean> list = new List();
        int length = data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(data[i]));
        }
        if (view != null) {
          view.onGetSingleIssueSuccess(issueBean);
          view.setList(list, isFromMore);
        }
      }
    }, (code, msg) {});
  }

  @override
  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("/") + 1)
        : "";
  }

  @override
  String getRepoAuthorName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/")) ?
    repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6, repoUrl.lastIndexOf("/")) : null;
  }

  @override
  editReactions(IssueBean item, repoUrl, comment, isIssue) {
    if (view != null) {
      view.showLoading();
    }
    _queryIssueCommentReaction(item, repoUrl, comment, isIssue);
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

  void _queryIssueCommentReaction(
      IssueBean issueBean, repoUrl, comment, isIssue) {
    int id;
    if (isIssue) {
      id = issueBean.number;
    } else {
      id = issueBean.id;
    }
    IssueManager.instance.getCommentReactions(repoUrl, id, comment, 1, isIssue,
        (data) {
      if (data != null) {
        int length = data.length;
        ReactionDetailBean findReaction = null;
        UserBean userBean = LoginManager.instance.getUserBean();
        for (int i = 0; i < length; i++) {
          ReactionDetailBean reactionDetailBean =
              ReactionDetailBean.fromJson(data[i]);
          if (reactionDetailBean != null &&
              reactionDetailBean.content == comment &&
              userBean != null &&
              reactionDetailBean.user != null &&
              userBean.login == reactionDetailBean.user.login) {
            findReaction = reactionDetailBean;
            break;
          }
        }
        if (findReaction != null) {
          _deleteIssueCommentReaction(
              issueBean, findReaction, comment, isIssue);
        } else {
          _createIssueCommentReaction(issueBean, repoUrl, comment, isIssue);
        }
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  void _createIssueCommentReaction(IssueBean item, repoUrl, comment, isIssue) {
    int id;
    if (isIssue) {
      id = item.number;
    } else {
      id = item.id;
    }
    IssueManager.instance.editReactions(repoUrl, id, comment, isIssue, (data) {
      if (view != null) {
        view.onEditSuccess(_addIssueBean(item, comment));
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  void _deleteIssueCommentReaction(
      IssueBean issueBean, ReactionDetailBean item, content, isIssue) {
    IssueManager.instance.deleteReactions(item.id, (data) {
      if (view != null) {
        view.onEditSuccess(_subtractionIssueBean(issueBean, content));
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  @override
  deleteIssueComment(IssueBean issueBean, repoUrl, comment_id) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance.deleteIssueComment(repoUrl, comment_id,
        (data) {
      if (view != null) {
        view.onDeleteSuccess(issueBean);
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
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
