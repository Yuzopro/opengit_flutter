import 'package:json_annotation/json_annotation.dart';

part 'user_bean.g.dart';

@JsonSerializable()
class UserBean {
  @JsonKey(name: 'login')
  String login;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'node_id')
  String nodeId;

  @JsonKey(name: 'avatar_url')
  String avatarUrl;

  @JsonKey(name: 'gravatar_id')
  String gravatarId;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'html_url')
  String htmlUrl;

  @JsonKey(name: 'followers_url')
  String followersUrl;

  @JsonKey(name: 'following_url')
  String followingUrl;

  @JsonKey(name: 'gists_url')
  String gistsUrl;

  @JsonKey(name: 'starred_url')
  String starredUrl;

  @JsonKey(name: 'subscriptions_url')
  String subscriptionsUrl;

  @JsonKey(name: 'organizations_url')
  String organizationsUrl;

  @JsonKey(name: 'repos_url')
  String reposUrl;

  @JsonKey(name: 'events_url')
  String eventsUrl;

  @JsonKey(name: 'received_events_url')
  String receivedEventsUrl;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'site_admin')
  bool siteAdmin;

  @JsonKey(name: 'blog')
  String blog;

  @JsonKey(name: 'public_repos')
  int publicRepos;

  @JsonKey(name: 'public_gists')
  int publicGists;

  @JsonKey(name: 'followers')
  int followers;

  @JsonKey(name: 'following')
  int following;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'private_gists')
  int privateGists;

  @JsonKey(name: 'total_private_repos')
  int totalPrivateRepos;

  @JsonKey(name: 'owned_private_repos')
  int ownedPrivateRepos;

  @JsonKey(name: 'disk_usage')
  int diskUsage;

  @JsonKey(name: 'collaborators')
  int collaborators;

  @JsonKey(name: 'two_factor_authentication')
  bool twoFactorAuthentication;

  @JsonKey(name: 'plan')
  Plan plan;
//  @JsonKey(name: 'company')
//  String company;
//  @JsonKey(name: 'location')
//  String location;
//  @JsonKey(name: 'email')
//  String email;
//  @JsonKey(name: 'bio')
//  String bio;

  UserBean(
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
    this.blog,
    this.publicRepos,
    this.publicGists,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
    this.privateGists,
    this.totalPrivateRepos,
    this.ownedPrivateRepos,
    this.diskUsage,
    this.collaborators,
    this.twoFactorAuthentication,
    this.plan,
//    this.company,
//    this.location,
//    this.email,
//    this.bio,
  );

  factory UserBean.fromJson(Map<String, dynamic> srcJson) =>
      _$UserBeanFromJson(srcJson);

  @override
  String toString() {
    return 'UserBean{login: $login, type: $type, siteAdmin: $siteAdmin}';
  }
}

@JsonSerializable()
class Plan {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'space')
  int space;

  @JsonKey(name: 'collaborators')
  int collaborators;

  @JsonKey(name: 'private_repos')
  int privateRepos;

  Plan(
    this.name,
    this.space,
    this.collaborators,
    this.privateRepos,
  );

  factory Plan.fromJson(Map<String, dynamic> srcJson) =>
      _$PlanFromJson(srcJson);
}
