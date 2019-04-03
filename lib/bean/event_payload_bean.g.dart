// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_payload_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPayloadBean _$EventPayloadBeanFromJson(Map<String, dynamic> json) {
  return EventPayloadBean()
    ..pushId = json['push_id'] as int
    ..size = json['size'] as int
    ..distinctSize = json['distinct_size'] as int
    ..ref = json['ref'] as String
    ..head = json['head'] as String
    ..before = json['before'] as String
    ..commits = (json['commits'] as List)
        ?.map((e) => e == null
            ? null
            : PushEventCommitBean.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..action = json['action'] as String
    ..refType = json['ref_type'] as String
    ..masterBranch = json['master_branch'] as String
    ..description = json['description'] as String
    ..pusherType = json['pusher_type'] as String
    ..release = json['release'] == null
        ? null
        : ReleaseBean.fromJson(json['release'] as Map<String, dynamic>)
    ..issue = json['issue'] == null
        ? null
        : IssueBean.fromJson(json['issue'] as Map<String, dynamic>)
    ..comment = json['comment'] == null
        ? null
        : IssueEventBean.fromJson(json['comment'] as Map<String, dynamic>);
}

Map<String, dynamic> _$EventPayloadBeanToJson(EventPayloadBean instance) =>
    <String, dynamic>{
      'push_id': instance.pushId,
      'size': instance.size,
      'distinct_size': instance.distinctSize,
      'ref': instance.ref,
      'head': instance.head,
      'before': instance.before,
      'commits': instance.commits,
      'action': instance.action,
      'ref_type': instance.refType,
      'master_branch': instance.masterBranch,
      'description': instance.description,
      'pusher_type': instance.pusherType,
      'release': instance.release,
      'issue': instance.issue,
      'comment': instance.comment
    };
