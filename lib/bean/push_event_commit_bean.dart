import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/user_bean.dart';


part 'push_event_commit_bean.g.dart';

@JsonSerializable()
class PushEventCommitBean {
  String sha;
  UserBean author;
  String message;
  bool distinct;
  String url;

  PushEventCommitBean(
    this.sha,
    this.author,
    this.message,
    this.distinct,
    this.url,
  );

  factory PushEventCommitBean.fromJson(Map<String, dynamic> json) => _$PushEventCommitBeanFromJson(json);

  @override
  String toString() {
    return 'PushEventCommitBean{sha: $sha, author: $author, message: $message, distinct: $distinct, url: $url}';
  }

}
