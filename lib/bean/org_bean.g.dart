// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrgBean _$OrgBeanFromJson(Map<String, dynamic> json) {
  return OrgBean(
    json['login'] as String,
    json['id'] as int,
    json['node_id'] as String,
    json['url'] as String,
    json['repos_url'] as String,
    json['events_url'] as String,
    json['hooks_url'] as String,
    json['issues_url'] as String,
    json['members_url'] as String,
    json['public_members_url'] as String,
    json['avatar_url'] as String,
    json['description'] as String,
    json['name'] as String,
    json['blog'] as String,
    json['company'] as String,
    json['location'] as String,
    json['email'] as String,
    json['is_verified'] as bool,
    json['has_organization_projects'] as bool,
    json['has_repository_projects'] as bool,
    json['public_repos'] as int,
    json['public_gists'] as int,
    json['followers'] as int,
    json['following'] as int,
    json['html_url'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$OrgBeanToJson(OrgBean instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'node_id': instance.nodeId,
      'url': instance.url,
      'company': instance.company,
      'repos_url': instance.reposUrl,
      'events_url': instance.eventsUrl,
      'hooks_url': instance.hooksUrl,
      'issues_url': instance.issuesUrl,
      'members_url': instance.membersUrl,
      'public_members_url': instance.publicMembersUrl,
      'avatar_url': instance.avatarUrl,
      'description': instance.description,
      'name': instance.name,
      'blog': instance.blog,
      'location': instance.location,
      'email': instance.email,
      'is_verified': instance.isVerified,
      'has_organization_projects': instance.hasOrganizationProjects,
      'has_repository_projects': instance.hasRepositoryProjects,
      'public_repos': instance.publicRepos,
      'public_gists': instance.publicGists,
      'followers': instance.followers,
      'following': instance.following,
      'html_url': instance.htmlUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'type': instance.type,
    };
