import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_event_bean.dart';
import 'package:open_git/bean/push_event_commit_bean.dart';
import 'package:open_git/bean/release_bean.dart';

part 'event_payload_bean.g.dart';

@JsonSerializable()
class EventPayloadBean {
  @JsonKey(name: "push_id")
  int pushId;
  int size;
  @JsonKey(name: "distinct_size")
  int distinctSize;
  String ref;
  String head;
  String before;

  List<PushEventCommitBean> commits;

  String action;
  @JsonKey(name: "ref_type")
  String refType;
  @JsonKey(name: "master_branch")
  String masterBranch;
  String description;
  @JsonKey(name: "pusher_type")
  String pusherType;

  ReleaseBean release;
  IssueBean issue;
  IssueEventBean comment;

  EventPayloadBean();

  factory EventPayloadBean.fromJson(Map<String, dynamic> json) =>
      _$EventPayloadBeanFromJson(json);

  @override
  String toString() {
    return 'EventPayloadBean{commits: $commits}';
  }
}
