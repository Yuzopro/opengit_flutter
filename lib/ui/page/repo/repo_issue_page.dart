import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/repo_issue_bloc.dart';
import 'package:open_git/ui/widget/issue_item_widget.dart';

class RepoIssuePage extends BaseListStatelessWidget<IssueBean, RepoIssueBloc> {
  @override
  PageType getPageType() {
    return PageType.repo_issue;
  }

  @override
  String getTitle(BuildContext context) {
    return 'Issues';
  }

  @override
  Widget builderItem(BuildContext context, IssueBean item) {
    return IssueItemWidget(item);
  }
}
