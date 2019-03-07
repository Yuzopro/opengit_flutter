// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_event_commit_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushEventCommitBean _$PushEventCommitBeanFromJson(Map<String, dynamic> json) =>
    new PushEventCommitBean(
        json['sha'] as String,
        json['author'] == null
            ? null
            : new UserBean.fromJson(json['author'] as Map<String, dynamic>),
        json['message'] as String,
        json['distinct'] as bool,
        json['url'] as String);

abstract class _$PushEventCommitBeanSerializerMixin {
  String get sha;
  UserBean get author;
  String get message;
  bool get distinct;
  String get url;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'sha': sha,
        'author': author,
        'message': message,
        'distinct': distinct,
        'url': url
      };
}
