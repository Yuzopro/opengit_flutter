import 'package:open_git/bean/issue_bean.dart';

class IssueDetailBean {
  IssueBean issueBean;
  List<IssueBean> comments;

  IssueDetailBean({this.issueBean, this.comments});
}
