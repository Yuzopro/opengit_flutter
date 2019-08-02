// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_language_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingLanguageBean _$TrendingLanguageBeanFromJson(Map<String, dynamic> json) {
  return TrendingLanguageBean(
    json['id'] as String,
    json['name'] as String,
    letter: json['letter'] as String,
  )..isShowLetter = json['isShowLetter'] as bool;
}

Map<String, dynamic> _$TrendingLanguageBeanToJson(
        TrendingLanguageBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'letter': instance.letter,
      'isShowLetter': instance.isShowLetter,
    };
