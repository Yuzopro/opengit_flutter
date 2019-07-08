import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';

class ReactionBloc extends BaseListBloc<ReactionDetailBean> {
  static final String TAG = "ReactionBloc";

  final IssueBean issueBean;
  final String reposUrl, content;
  final bool isIssue;

  bool _isInit = false;

  ReactionBloc(this.issueBean, this.reposUrl, this.content, this.isIssue);

  @override
  ListPageType getListPageType() {
    return ListPageType.reaction;
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchReactions();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchReactions();
  }

  deleteReactions(BuildContext context, reactionId) async {
    _showLoading();
    final response = await IssueManager.instance.deleteReactions(reactionId);
    if (response != null && response.result) {
      Navigator.pop(context, _refreshIssueBean(issueBean, content));
    }
    _hideLoading();
  }

  Future _fetchReactions() async {
    LogUtil.v('_fetchReactions', tag: TAG);
    try {
      int id;
      if (isIssue) {
        id = issueBean.number;
      } else {
        id = issueBean.id;
      }

      var result = await IssueManager.instance
          .getCommentReactions(reposUrl, id, content, page, isIssue);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      }

      sink.add(bean);
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }

  IssueBean _refreshIssueBean(IssueBean issueBean, String comment) {
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

  void _showLoading() {
    bean.isLoading = true;
    sink.add(bean);
  }

  void _hideLoading() {
    bean.isLoading = false;
    sink.add(bean);
  }
}
