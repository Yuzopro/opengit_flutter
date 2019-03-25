import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/user_bean.dart';

part 'issue_bean.g.dart';

@JsonSerializable()
class IssueBean {
  int id;
  int number;
  String title;
  String state;
  bool locked;
  @JsonKey(name: "comments")
  int commentNum;

  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "closed_at")
  DateTime closedAt;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;

  UserBean user;
  @JsonKey(name: "repository_url")
  String repoUrl;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "closed_by")
  UserBean closeBy;



  IssueBean(
    this.id,
    this.number,
    this.title,
    this.state,
    this.locked,
    this.commentNum,
    this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.body,
    this.bodyHtml,
    this.user,
    this.repoUrl,
    this.htmlUrl,
    this.closeBy,
  );

  factory IssueBean.fromJson(Map<String, dynamic> json) => _$IssueBeanFromJson(json);

  @override
  String toString() {
    return 'IssueBean{number: $number, title: $title, commentNum: $commentNum, user: $user}';
  }

}
