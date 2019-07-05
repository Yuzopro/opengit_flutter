import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/mvp/base/base_presenter.dart';
import 'package:open_git/mvp/base/i_base_pull_list_view.dart';

abstract class IDeleteReactionPresenter<V extends IDeleteReactionView> extends BasePresenter<V>{
  deleteReactions(IssueBean item, reaction_id, content);
  getCommentReactions(repoUrl, commentId, content, page, isIssue, isFromMore);
}

abstract class IDeleteReactionView extends IBasePullListView<ReactionDetailBean> {
  void onEditSuccess(IssueBean issueBean);
}
