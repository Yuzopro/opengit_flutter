import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_bloc.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_detail_bean.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bean/reaction_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/route/navigator_util.dart';

class IssueDetailBloc extends BaseBloc<LoadingBean<IssueDetailBean>> {
  static final String TAG = "IssueDetailBloc";

  final String url, num;

  bool _isInit = false;

  IssueDetailBloc(this.url, this.num) {
    bean = LoadingBean(isLoading: false, data: IssueDetailBean(comments: []));
  }

  void onRefresh() async {
    page = 1;
    super.onRefresh();
  }

  void onLoadMore() async {
    page++;
    super.onLoadMore();
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchIssueComment();
    await _fetchIssueComments();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchIssueComments();
  }

  String getTitle() {
    String title = (url.isNotEmpty && url.contains("/"))
        ? url.substring(url.lastIndexOf("/") + 1)
        : "";
    return "$title # $num";
  }

  void updateLabels() {
    List<Labels> labels = IssueManager.instance.getLabels();
    if (labels == null || labels.isEmpty) {
      return;
    }
    bean.data.issueBean.labels = labels;
    sink.add(bean);
  }

  bool isEditAndDeleteEnable(IssueBean item) {
    if (item == null ||
        item.user == null ||
        item.user.login == null ||
        bean.data.issueBean == null ||
        bean.data.issueBean.user == null ||
        bean.data.issueBean.user.login == null) {
      return false;
    }

    String authorName = getRepoAuthorName();
    if (UserManager.instance.isYou(authorName)) {
      return true;
    } else if (UserManager.instance.isYou(item.user.login)) {
      return true;
    }

    return false;
  }

  goEditIssue(BuildContext context) async {
    final result =
        await NavigatorUtil.goEditIssue(context, bean.data.issueBean);
    if (result == null) {
      return;
    }
    bean.data.issueBean = result;
    sink.add(bean);
  }

  enterCommentEditor(BuildContext context, IssueBean item, bool isAdd) async {
    final result =
        await NavigatorUtil.goEditIssueComment(context, item, url, isAdd);
    if (isAdd) {
      _addSuccess(result);
    } else {
      _editSuccess(result);
    }
  }

  goDeleteReaction(
      BuildContext context, IssueBean item, content, isIssue) async {
    int id = isIssue ? item.number : item.id;
    final result = await NavigatorUtil.goDeleteReaction(
        context, url, content, isIssue, id);
    if (result != null) {
      _subtractionIssueBean(item, result);
    }
  }

  void deleteIssueComment(IssueBean item) async {
    showLoading();
    int comment_id = item.id;
    final response =
        await IssueManager.instance.deleteIssueComment(url, comment_id);
    if (response != null && response.result) {
      bean.data.comments.remove(item);
      sink.add(bean);
    }
    hideLoading();
  }

  editReactions(IssueBean item, comment, isIssue) async {
    showLoading();
    await _queryIssueCommentReaction(item, comment, isIssue);
    hideLoading();
  }

  _queryIssueCommentReaction(IssueBean item, comment, isIssue) async {
    int id;
    if (isIssue) {
      id = item.number;
    } else {
      id = item.id;
    }
    final response = await IssueManager.instance
        .getCommentReactions(url, id, comment, 1, isIssue);
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
      return await _deleteIssueCommentReaction(item, findReaction, comment);
    } else {
      return await _createIssueCommentReaction(item, comment, isIssue);
    }
  }

  _createIssueCommentReaction(IssueBean item, comment, isIssue) async {
    int id;
    if (isIssue) {
      id = item.number;
    } else {
      id = item.id;
    }
    final response =
        await IssueManager.instance.editReactions(url, id, comment, isIssue);
    if (response != null && response.result) {
      _addIssueBean(item, comment);
      sink.add(bean);
    }
    return response;
  }

  _deleteIssueCommentReaction(
      IssueBean issueBean, ReactionDetailBean item, content) async {
    final response = await IssueManager.instance.deleteReactions(item.id);
    _subtractionIssueBean(issueBean, content);
    sink.add(bean);
    return response;
  }

  Future _fetchIssueComments() async {
    try {
      var result = await IssueManager.instance
          .getIssueComment(url, num, page);
      if (bean.data == null) {
        bean.data.comments = List();
      }
      if (page == 1) {
        bean.data.comments.clear();
      }

      noMore = true;
      if (result != null) {
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.comments.addAll(result);
      } else {
        bean.isError = true;
      }

      sink.add(bean);
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }

  void _fetchIssueComment() async {
    IssueBean result =
        await IssueManager.instance.getSingleIssue(url, num);
    bean.data.issueBean = result;
  }

  String getRepoAuthorName() {
    String repoUrl = url;
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(
            repoUrl.lastIndexOf("repos/") + 6, repoUrl.lastIndexOf("/"))
        : null;
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
    if (issueBean.reaction == null) {
      issueBean.reaction = ReactionBean('', 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }
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

  void _addSuccess(IssueBean result) {
    if (result == null) {
      return;
    }
    bean.data.comments.add(result);
    sink.add(bean);
  }

  void _editSuccess(IssueBean result) {
    if (result == null) {
      return;
    }
    int index = -1;
    for (int i = 0; i < bean.data.comments.length; i++) {
      IssueBean issueBean = bean.data.comments[i];
      if (issueBean.id == result.id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      bean.data.comments.removeAt(index);
      bean.data.comments.insert(index, result);
      sink.add(bean);
    }
  }
}
