import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/event_payload_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';

part 'event_bean.g.dart';

@JsonSerializable()
class EventBean {
  String id;
  String type;
  UserBean actor;
  Repository repo;
  UserBean org;
  EventPayloadBean payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  EventBean(
    this.id,
    this.type,
    this.actor,
    this.repo,
    this.org,
    this.payload,
    this.isPublic,
    this.createdAt,
  );

  factory EventBean.fromJson(Map<String, dynamic> json) =>
      _$EventBeanFromJson(json);

  @override
  String toString() {
    return 'EventBean{id: $id, type: $type, payload: $payload}';
  }
}
