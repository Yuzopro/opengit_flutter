// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_repos_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingReposBean _$TrendingReposBeanFromJson(Map<String, dynamic> json) {
  return TrendingReposBean(
    json['author'] as String,
    json['name'] as String,
    json['avatar'] as String,
    json['url'] as String,
    json['description'] as String,
    json['language'] as String,
    json['languageColor'] as String,
    json['stars'] as int,
    json['forks'] as int,
    json['currentPeriodStars'] as int,
    (json['builtBy'] as List)
        ?.map((e) =>
            e == null ? null : BuiltBy.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TrendingReposBeanToJson(TrendingReposBean instance) =>
    <String, dynamic>{
      'author': instance.author,
      'name': instance.name,
      'avatar': instance.avatar,
      'url': instance.url,
      'description': instance.description,
      'language': instance.language,
      'languageColor': instance.languageColor,
      'stars': instance.stars,
      'forks': instance.forks,
      'currentPeriodStars': instance.currentPeriodStars,
      'builtBy': instance.builtBy,
    };

BuiltBy _$BuiltByFromJson(Map<String, dynamic> json) {
  return BuiltBy(
    json['href'] as String,
    json['avatar'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$BuiltByToJson(BuiltBy instance) => <String, dynamic>{
      'href': instance.href,
      'avatar': instance.avatar,
      'username': instance.username,
    };
