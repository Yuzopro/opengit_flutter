import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';

class ReactionBloc extends BaseListBloc<ReactionDetailBean> {
  static final String TAG = "ReactionBloc";

  final String reposUrl, content, id;
  final bool isIssue;

  ReactionBloc(this.reposUrl, this.content, this.isIssue, this.id);

  @override
  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchReactions();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchReactions();
  }

  deleteReactions(BuildContext context, reactionId) async {
    showLoading();
    final response = await IssueManager.instance.deleteReactions(reactionId);
    if (response != null && response.result) {
      Navigator.pop(context, content);
    }
    hideLoading();
  }

  Future _fetchReactions() async {
    LogUtil.v('_fetchReactions', tag: TAG);
    try {
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
