// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_event_commit_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushEventCommitBean _$PushEventCommitBeanFromJson(Map<String, dynamic> json) {
  return PushEventCommitBean(
      json['sha'] as String,
      json['author'] == null
          ? null
          : UserBean.fromJson(json['author'] as Map<String, dynamic>),
      json['message'] as String,
      json['distinct'] as bool,
      json['url'] as String);
}

Map<String, dynamic> _$PushEventCommitBeanToJson(
        PushEventCommitBean instance) =>
    <String, dynamic>{
      'sha': instance.sha,
      'author': instance.author,
      'message': instance.message,
      'distinct': instance.distinct,
      'url': instance.url
    };
