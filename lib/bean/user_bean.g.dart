// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean(
    json['login'] as String,
    json['name'] as String,
    json['id'] as int,
    json['node_id'] as String,
    json['avatar_url'] as String,
    json['gravatar_id'] as String,
    json['url'] as String,
    json['html_url'] as String,
    json['followers_url'] as String,
    json['following_url'] as String,
    json['gists_url'] as String,
    json['starred_url'] as String,
    json['subscriptions_url'] as String,
    json['organizations_url'] as String,
    json['repos_url'] as String,
    json['events_url'] as String,
    json['received_events_url'] as String,
    json['type'] as String,
    json['site_admin'] as bool,
    json['blog'] as String,
    json['public_repos'] as int,
    json['public_gists'] as int,
    json['followers'] as int,
    json['following'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['private_gists'] as int,
    json['total_private_repos'] as int,
    json['owned_private_repos'] as int,
    json['disk_usage'] as int,
    json['collaborators'] as int,
    json['two_factor_authentication'] as bool,
    json['plan'] == null
        ? null
        : Plan.fromJson(json['plan'] as Map<String, dynamic>),
    json['company'] as String,
    json['location'] as String,
    json['email'] as String,
    json['bio'] as String,
  )..isFollow = json['isFollow'] as bool;
}

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'id': instance.id,
      'node_id': instance.nodeId,
      'avatar_url': instance.avatarUrl,
      'gravatar_id': instance.gravatarId,
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'followers_url': instance.followersUrl,
      'following_url': instance.followingUrl,
      'gists_url': instance.gistsUrl,
      'starred_url': instance.starredUrl,
      'subscriptions_url': instance.subscriptionsUrl,
      'organizations_url': instance.organizationsUrl,
      'repos_url': instance.reposUrl,
      'events_url': instance.eventsUrl,
      'received_events_url': instance.receivedEventsUrl,
      'type': instance.type,
      'site_admin': instance.siteAdmin,
      'blog': instance.blog,
      'public_repos': instance.publicRepos,
      'public_gists': instance.publicGists,
      'followers': instance.followers,
      'following': instance.following,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'private_gists': instance.privateGists,
      'total_private_repos': instance.totalPrivateRepos,
      'owned_private_repos': instance.ownedPrivateRepos,
      'disk_usage': instance.diskUsage,
      'collaborators': instance.collaborators,
      'two_factor_authentication': instance.twoFactorAuthentication,
      'plan': instance.plan.toJson,
      'company': instance.company,
      'location': instance.location,
      'email': instance.email,
      'bio': instance.bio,
      'isFollow': instance.isFollow,
    };

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return Plan(
    json['name'] as String,
    json['space'] as int,
    json['collaborators'] as int,
    json['private_repos'] as int,
  );
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'name': instance.name,
      'space': instance.space,
      'collaborators': instance.collaborators,
      'private_repos': instance.privateRepos,
    };
