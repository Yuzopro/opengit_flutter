// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_topics_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepoTopicsBean _$RepoTopicsBeanFromJson(Map<String, dynamic> json) {
  return RepoTopicsBean(
    (json['names'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$RepoTopicsBeanToJson(RepoTopicsBean instance) =>
    <String, dynamic>{
      'names': instance.names,
    };
