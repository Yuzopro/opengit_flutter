// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_event_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueEventBean _$IssueEventBeanFromJson(Map<String, dynamic> json) {
  return IssueEventBean(
      json['id'] as int,
      json['user'] == null
          ? null
          : UserBean.fromJson(json['user'] as Map<String, dynamic>),
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      json['author_association'] as String,
      json['body'] as String,
      json['body_html'] as String,
      json['event'] as String,
      json['html_url'] as String);
}
