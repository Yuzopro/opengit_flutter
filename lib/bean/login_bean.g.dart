// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBean _$LoginBeanFromJson(Map<String, dynamic> json) => new LoginBean(
    json['id'] as int,
    json['url'] as String,
    json['app'] == null
        ? null
        : new App.fromJson(json['app'] as Map<String, dynamic>),
    json['token'] as String,
    json['hashed_token'] as String,
    json['token_last_eight'] as String,
    json['note'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['scopes'] as List)?.map((e) => e as String)?.toList());

abstract class _$LoginBeanSerializerMixin {
  int get id;
  String get url;
  App get app;
  String get token;
  String get hashedToken;
  String get tokenLastEight;
  String get note;
  String get createdAt;
  String get updatedAt;
  List<String> get scopes;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'app': app,
        'token': token,
        'hashed_token': hashedToken,
        'token_last_eight': tokenLastEight,
        'note': note,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'scopes': scopes
      };
}

App _$AppFromJson(Map<String, dynamic> json) => new App(
    json['name'] as String, json['url'] as String, json['client_id'] as String);

abstract class _$AppSerializerMixin {
  String get name;
  String get url;
  String get clientId;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'url': url, 'client_id': clientId};
}
