// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventBean _$EventBeanFromJson(Map<String, dynamic> json) {
  return EventBean(
      json['id'] as String,
      json['type'] as String,
      json['actor'] == null
          ? null
          : UserBean.fromJson(json['actor'] as Map<String, dynamic>),
      json['repo'] == null
          ? null
          : Repository.fromJson(json['repo'] as Map<String, dynamic>),
      json['org'] == null
          ? null
          : UserBean.fromJson(json['org'] as Map<String, dynamic>),
      json['payload'] == null
          ? null
          : EventPayloadBean.fromJson(json['payload'] as Map<String, dynamic>),
      json['public'] as bool,
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String));
}

Map<String, dynamic> _$EventBeanToJson(EventBean instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'actor': instance.actor,
      'repo': instance.repo,
      'org': instance.org,
      'payload': instance.payload,
      'public': instance.isPublic,
      'created_at': instance.createdAt?.toIso8601String()
    };
