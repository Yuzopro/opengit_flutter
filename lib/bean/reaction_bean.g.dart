// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionBean _$ReactionBeanFromJson(Map<String, dynamic> json) {
  return ReactionBean(
      json['url'] as String,
      json['total_count'] as int,
      json['+1'] as int,
      json['-1'] as int,
      json['laugh'] as int,
      json['hooray'] as int,
      json['confused'] as int,
      json['heart'] as int,
      json['rocket'] as int,
      json['eyes'] as int);
}

Map<String, dynamic> _$ReactionBeanToJson(ReactionBean instance) =>
    <String, dynamic>{
      'url': instance.url,
      'total_count': instance.totalCount,
      '+1': instance.like,
      '-1': instance.noLike,
      'laugh': instance.laugh,
      'hooray': instance.hooray,
      'confused': instance.confused,
      'heart': instance.heart,
      'rocket': instance.rocket,
      'eyes': instance.eyes
    };
