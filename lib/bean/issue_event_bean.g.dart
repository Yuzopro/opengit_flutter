// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_event_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueEventBean _$IssueEventBeanFromJson(Map<String, dynamic> json) =>
    new IssueEventBean(
        json['id'] as int,
        json['user'] == null
            ? null
            : new UserBean.fromJson(json['user'] as Map<String, dynamic>),
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

abstract class _$IssueEventBeanSerializerMixin {
  int get id;
  UserBean get user;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get authorAssociation;
  String get body;
  String get bodyHtml;
  String get type;
  String get htmlUrl;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user': user,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'author_association': authorAssociation,
        'body': body,
        'body_html': bodyHtml,
        'event': type,
        'html_url': htmlUrl
      };
}
