// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_detail_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionDetailBean _$ReactionDetailBeanFromJson(Map<String, dynamic> json) {
  return ReactionDetailBean(
      json['id'] as int,
      json['node_id'] as String,
      json['user'] == null
          ? null
          : UserBean.fromJson(json['user'] as Map<String, dynamic>),
      json['content'] as String,
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String));
}

Map<String, dynamic> _$ReactionDetailBeanToJson(ReactionDetailBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'user': instance.user,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String()
    };
