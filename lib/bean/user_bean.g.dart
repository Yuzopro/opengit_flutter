// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) => new UserBean(
    json['login'] as String,
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
        : new Plan.fromJson(json['plan'] as Map<String, dynamic>));

abstract class _$UserBeanSerializerMixin {
  String get login;
  int get id;
  String get nodeId;
  String get avatarUrl;
  String get gravatarId;
  String get url;
  String get htmlUrl;
  String get followersUrl;
  String get followingUrl;
  String get gistsUrl;
  String get starredUrl;
  String get subscriptionsUrl;
  String get organizationsUrl;
  String get reposUrl;
  String get eventsUrl;
  String get receivedEventsUrl;
  String get type;
  bool get siteAdmin;
  String get blog;
  int get publicRepos;
  int get publicGists;
  int get followers;
  int get following;
  String get createdAt;
  String get updatedAt;
  int get privateGists;
  int get totalPrivateRepos;
  int get ownedPrivateRepos;
  int get diskUsage;
  int get collaborators;
  bool get twoFactorAuthentication;
  Plan get plan;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'login': login,
        'id': id,
        'node_id': nodeId,
        'avatar_url': avatarUrl,
        'gravatar_id': gravatarId,
        'url': url,
        'html_url': htmlUrl,
        'followers_url': followersUrl,
        'following_url': followingUrl,
        'gists_url': gistsUrl,
        'starred_url': starredUrl,
        'subscriptions_url': subscriptionsUrl,
        'organizations_url': organizationsUrl,
        'repos_url': reposUrl,
        'events_url': eventsUrl,
        'received_events_url': receivedEventsUrl,
        'type': type,
        'site_admin': siteAdmin,
        'blog': blog,
        'public_repos': publicRepos,
        'public_gists': publicGists,
        'followers': followers,
        'following': following,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'private_gists': privateGists,
        'total_private_repos': totalPrivateRepos,
        'owned_private_repos': ownedPrivateRepos,
        'disk_usage': diskUsage,
        'collaborators': collaborators,
        'two_factor_authentication': twoFactorAuthentication,
        'plan': plan
      };
}

Plan _$PlanFromJson(Map<String, dynamic> json) => new Plan(
    json['name'] as String,
    json['space'] as int,
    json['collaborators'] as int,
    json['private_repos'] as int);

abstract class _$PlanSerializerMixin {
  String get name;
  int get space;
  int get collaborators;
  int get privateRepos;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'space': space,
        'collaborators': collaborators,
        'private_repos': privateRepos
      };
}
