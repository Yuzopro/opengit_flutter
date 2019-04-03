import 'package:json_annotation/json_annotation.dart';

part 'branch_bean.g.dart';

@JsonSerializable()
class BranchBean{
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'commit')
  Commit commit;

  @JsonKey(name: 'protected')
  bool protected;

  @JsonKey(name: 'protection')
  Protection protection;

  @JsonKey(name: 'protection_url')
  String protectionUrl;

  BranchBean(
    this.name,
    this.commit,
    this.protected,
    this.protection,
    this.protectionUrl,
  );

  factory BranchBean.fromJson(Map<String, dynamic> srcJson) =>
      _$BranchBeanFromJson(srcJson);
}

@JsonSerializable()
class Commit extends Object {
  @JsonKey(name: 'sha')
  String sha;

  @JsonKey(name: 'url')
  String url;

  Commit(
    this.sha,
    this.url,
  );

  factory Commit.fromJson(Map<String, dynamic> srcJson) =>
      _$CommitFromJson(srcJson);
}

@JsonSerializable()
class Protection extends Object {
  @JsonKey(name: 'enabled')
  bool enabled;

  @JsonKey(name: 'required_status_checks')
  Required_status_checks requiredStatusChecks;

  Protection(
    this.enabled,
    this.requiredStatusChecks,
  );

  factory Protection.fromJson(Map<String, dynamic> srcJson) =>
      _$ProtectionFromJson(srcJson);
}

@JsonSerializable()
class Required_status_checks {
  @JsonKey(name: 'enforcement_level')
  String enforcementLevel;

  @JsonKey(name: 'contexts')
  List<dynamic> contexts;

  Required_status_checks(
    this.enforcementLevel,
    this.contexts,
  );

  factory Required_status_checks.fromJson(Map<String, dynamic> srcJson) =>
      _$Required_status_checksFromJson(srcJson);
}
