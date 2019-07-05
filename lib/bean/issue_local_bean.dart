import 'package:open_git/bean/issue_bean.dart';

class IssueLocalBean {
  List<IssueBean> issues;
  String q, state, sort, order;

  IssueLocalBean({this.issues, this.q, this.state, this.sort, this.order});

  void copyWith({
    String q,
    String state,
    String sort,
    String order,
  }) {
    this.q = q ?? this.q;
    this.state = state ?? this.state;
    this.sort = sort ?? this.sort;
    this.order = order ?? this.order;
  }

  @override
  String toString() {
    return 'IssueLocalBean{q: $q, state: $state, sort: $sort, order: $order}';
  }
}
