// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchBean _$BranchBeanFromJson(Map<String, dynamic> json) {
  return BranchBean(
    json['name'] as String,
    json['commit'] == null
        ? null
        : Commit.fromJson(json['commit'] as Map<String, dynamic>),
    json['protected'] as bool,
    json['protection'] == null
        ? null
        : Protection.fromJson(json['protection'] as Map<String, dynamic>),
    json['protection_url'] as String,
  );
}

Map<String, dynamic> _$BranchBeanToJson(BranchBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'commit': instance.commit,
      'protected': instance.protected,
      'protection': instance.protection,
      'protection_url': instance.protectionUrl,
    };

Commit _$CommitFromJson(Map<String, dynamic> json) {
  return Commit(
    json['sha'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$CommitToJson(Commit instance) => <String, dynamic>{
      'sha': instance.sha,
      'url': instance.url,
    };

Protection _$ProtectionFromJson(Map<String, dynamic> json) {
  return Protection(
    json['enabled'] as bool,
    json['required_status_checks'] == null
        ? null
        : Required_status_checks.fromJson(
            json['required_status_checks'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProtectionToJson(Protection instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'required_status_checks': instance.requiredStatusChecks,
    };

Required_status_checks _$Required_status_checksFromJson(
    Map<String, dynamic> json) {
  return Required_status_checks(
    json['enforcement_level'] as String,
    json['contexts'] as List,
  );
}

Map<String, dynamic> _$Required_status_checksToJson(
        Required_status_checks instance) =>
    <String, dynamic>{
      'enforcement_level': instance.enforcementLevel,
      'contexts': instance.contexts,
    };
