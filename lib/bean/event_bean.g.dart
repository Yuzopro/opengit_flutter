// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventBean _$EventBeanFromJson(Map<String, dynamic> json) => new EventBean(
    json['id'] as String,
    json['type'] as String,
    json['actor'] == null
        ? null
        : new UserBean.fromJson(json['actor'] as Map<String, dynamic>),
    json['repo'] == null
        ? null
        : new Repository.fromJson(json['repo'] as Map<String, dynamic>),
    json['org'] == null
        ? null
        : new UserBean.fromJson(json['org'] as Map<String, dynamic>),
    json['payload'] == null
        ? null
        : new EventPayloadBean.fromJson(
            json['payload'] as Map<String, dynamic>),
    json['public'] as bool,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String));

abstract class _$EventBeanSerializerMixin {
  String get id;
  String get type;
  UserBean get actor;
  Repository get repo;
  UserBean get org;
  EventPayloadBean get payload;
  bool get isPublic;
  DateTime get createdAt;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'actor': actor,
        'repo': repo,
        'org': org,
        'payload': payload,
        'public': isPublic,
        'created_at': createdAt?.toIso8601String()
      };
}
