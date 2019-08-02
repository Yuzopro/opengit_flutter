import 'package:json_annotation/json_annotation.dart';

part 'org_bean.g.dart';

List<OrgBean> getOrgBeanList(List<dynamic> list) {
  List<OrgBean> result = [];
  list.forEach((item) {
    result.add(OrgBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class OrgBean extends Object {
  @JsonKey(name: 'login')
  String login;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'node_id')
  String nodeId;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'company')
  String company;

  @JsonKey(name: 'repos_url')
  String reposUrl;

  @JsonKey(name: 'events_url')
  String eventsUrl;

  @JsonKey(name: 'hooks_url')
  String hooksUrl;

  @JsonKey(name: 'issues_url')
  String issuesUrl;

  @JsonKey(name: 'members_url')
  String membersUrl;

  @JsonKey(name: 'public_members_url')
  String publicMembersUrl;

  @JsonKey(name: 'avatar_url')
  String avatarUrl;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'blog')
  String blog;

  @JsonKey(name: 'location')
  String location;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'is_verified')
  bool isVerified;

  @JsonKey(name: 'has_organization_projects')
  bool hasOrganizationProjects;

  @JsonKey(name: 'has_repository_projects')
  bool hasRepositoryProjects;

  @JsonKey(name: 'public_repos')
  int publicRepos;

  @JsonKey(name: 'public_gists')
  int publicGists;

  @JsonKey(name: 'followers')
  int followers;

  @JsonKey(name: 'following')
  int following;

  @JsonKey(name: 'html_url')
  String htmlUrl;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'type')
  String type;

  OrgBean(
    this.login,
    this.id,
    this.nodeId,
    this.url,
    this.reposUrl,
    this.eventsUrl,
    this.hooksUrl,
    this.issuesUrl,
    this.membersUrl,
    this.publicMembersUrl,
    this.avatarUrl,
    this.description,
    this.name,
    this.blog,
    this.company,
    this.location,
    this.email,
    this.isVerified,
    this.hasOrganizationProjects,
    this.hasRepositoryProjects,
    this.publicRepos,
    this.publicGists,
    this.followers,
    this.following,
    this.htmlUrl,
    this.createdAt,
    this.updatedAt,
    this.type,
  );

  factory OrgBean.fromJson(Map<String, dynamic> srcJson) =>
      _$OrgBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrgBeanToJson(this);
}
