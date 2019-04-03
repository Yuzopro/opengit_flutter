// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBean _$LoginBeanFromJson(Map<String, dynamic> json) {
  return LoginBean(
      json['id'] as int,
      json['url'] as String,
      json['app'] == null
          ? null
          : App.fromJson(json['app'] as Map<String, dynamic>),
      json['token'] as String,
      json['hashed_token'] as String,
      json['token_last_eight'] as String,
      json['note'] as String,
      json['created_at'] as String,
      json['updated_at'] as String,
      (json['scopes'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$LoginBeanToJson(LoginBean instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'app': instance.app,
      'token': instance.token,
      'hashed_token': instance.hashedToken,
      'token_last_eight': instance.tokenLastEight,
      'note': instance.note,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'scopes': instance.scopes
    };

App _$AppFromJson(Map<String, dynamic> json) {
  return App(json['name'] as String, json['url'] as String,
      json['client_id'] as String);
}

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'client_id': instance.clientId
    };
