// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackBean _$TrackBeanFromJson(Map<String, dynamic> json) {
  return TrackBean(
    json['_id'] as int,
    json['url'] as String,
    json['title'] as String,
    json['type'] as String,
    json['repo_owner'] as String,
    json['repo_name'] as String,
    json['issue_number'] as String,
    json['date'] as int,
    json['data1'] as String,
    json['data2'] as String,
    json['data3'] as String,
    json['data4'] as String,
  );
}

Map<String, dynamic> _$TrackBeanToJson(TrackBean instance) => <String, dynamic>{
      '_id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'type': instance.type,
      'repo_owner': instance.repoOwner,
      'repo_name': instance.repoName,
      'issue_number': instance.issueNumber,
      'date': instance.date,
      'data1': instance.data1,
      'data2': instance.data2,
      'data3': instance.data3,
      'data4': instance.data4,
    };
