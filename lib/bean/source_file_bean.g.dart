// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_file_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFileBean _$SourceFileBeanFromJson(Map<String, dynamic> json) {
  return SourceFileBean(
      json['name'] as String,
      json['path'] as String,
      json['sha'] as String,
      json['size'] as int,
      json['url'] as String,
      json['html_url'] as String,
      json['git_url'] as String,
      json['download_url'] as String,
      json['type'] as String);
}

Map<String, dynamic> _$SourceFileBeanToJson(SourceFileBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'sha': instance.sha,
      'size': instance.size,
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'git_url': instance.gitUrl,
      'download_url': instance.downloadUrl,
      'type': instance.type
    };
