import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/issue_detail_contract.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';

class IssueDetailPresenter extends IIssueDetailPresenter {
  @override
  getIssueComment(repoUrl, issueNumber, page, isFromMore) {
    return IssueManager.instance.getIssueComment(repoUrl, issueNumber, page,
        (data) {
      if (data != null && data.length > 0) {
        List<IssueBean> list = new List();
        int length = data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(data[i]));
        }
        if (view != null) {
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
  addIssueComment(repoUrl, issueNumber, comment) {
    return IssueManager.instance.addIssueComment(repoUrl, issueNumber, comment, (data) {}, (code, msg) {});
  }

  @override
  editReactions(IssueBean item, repoUrl, comment) {
    if (view != null) {
      view.showLoading();
    }
    return IssueManager.instance
        .editReactions(repoUrl, item.id, comment, (data) {
      if (view != null) {
        view.onEditSuccess(_refreshIssueBean(item, comment));
        view.hideLoading();
      }
    }, (code, msg) {
      if (view != null) {
        view.hideLoading();
      }
    });
  }

  bool isEditAndDeleteEnable(IssueBean item) {
    if (item == null || item.user == null || item.user.login == null) {
      return false;
    }
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null && userBean.login == item.user.login) {
      return true;
    }
    return false;
  }

  IssueBean _refreshIssueBean(IssueBean issueBean, String comment) {
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
