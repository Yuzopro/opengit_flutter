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
      json['protection_url'] as String);
}

Commit _$CommitFromJson(Map<String, dynamic> json) {
  return Commit(json['sha'] as String, json['url'] as String);
}

Protection _$ProtectionFromJson(Map<String, dynamic> json) {
  return Protection(
      json['enabled'] as bool,
      json['required_status_checks'] == null
          ? null
          : Required_status_checks.fromJson(
              json['required_status_checks'] as Map<String, dynamic>));
}

Required_status_checks _$Required_status_checksFromJson(
    Map<String, dynamic> json) {
  return Required_status_checks(
      json['enforcement_level'] as String, json['contexts'] as List);
}