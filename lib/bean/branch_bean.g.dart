// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchBean _$BranchBeanFromJson(Map<String, dynamic> json) => new BranchBean(
    json['name'] as String,
    json['commit'] == null
        ? null
        : new Commit.fromJson(json['commit'] as Map<String, dynamic>),
    json['protected'] as bool,
    json['protection'] == null
        ? null
        : new Protection.fromJson(json['protection'] as Map<String, dynamic>),
    json['protection_url'] as String);

abstract class _$BranchBeanSerializerMixin {
  String get name;
  Commit get commit;
  bool get protected;
  Protection get protection;
  String get protectionUrl;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'commit': commit,
        'protected': protected,
        'protection': protection,
        'protection_url': protectionUrl
      };
}

Commit _$CommitFromJson(Map<String, dynamic> json) =>
    new Commit(json['sha'] as String, json['url'] as String);

abstract class _$CommitSerializerMixin {
  String get sha;
  String get url;
  Map<String, dynamic> toJson() => <String, dynamic>{'sha': sha, 'url': url};
}

Protection _$ProtectionFromJson(Map<String, dynamic> json) => new Protection(
    json['enabled'] as bool,
    json['required_status_checks'] == null
        ? null
        : new Required_status_checks.fromJson(
            json['required_status_checks'] as Map<String, dynamic>));

abstract class _$ProtectionSerializerMixin {
  bool get enabled;
  Required_status_checks get requiredStatusChecks;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'enabled': enabled,
        'required_status_checks': requiredStatusChecks
      };
}

Required_status_checks _$Required_status_checksFromJson(
        Map<String, dynamic> json) =>
    new Required_status_checks(
        json['enforcement_level'] as String, json['contexts'] as List);

abstract class _$Required_status_checksSerializerMixin {
  String get enforcementLevel;
  List<dynamic> get contexts;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'enforcement_level': enforcementLevel,
        'contexts': contexts
      };
}
