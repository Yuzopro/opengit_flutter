import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/user_bean.dart';

/**
 * Created by guoshuyu
 * Date: 2018-07-31
 */

part 'issue_event_bean.g.dart';

@JsonSerializable()
class IssueEventBean{
  int id;
  UserBean user;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "author_association")
  String authorAssociation;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;
  @JsonKey(name: "event")
  String type;
  @JsonKey(name: "html_url")
  String htmlUrl;

  IssueEventBean(
    this.id,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.authorAssociation,
    this.body,
    this.bodyHtml,
    this.type,
    this.htmlUrl,
  );

  factory IssueEventBean.fromJson(Map<String, dynamic> json) => _$IssueEventBeanFromJson(json);
}
