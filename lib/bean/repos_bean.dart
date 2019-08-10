import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/license_bean.dart';
import 'package:open_git/bean/repos_permissions_bean.dart';
import 'package:open_git/bean/user_bean.dart';

part 'repos_bean.g.dart';

@JsonSerializable()
class Repository {
  int id;

  int size;

  String name;

  @JsonKey(name: "full_name")
  String fullName;

  String stargazers_url;

  String contributors_url;

  String subscribers_url;

  @JsonKey(name: "html_url")
  String htmlUrl;

  String description;

  String language;

  @JsonKey(name: "default_branch")
  String defaultBranch;

  @JsonKey(name: "created_at")
  DateTime createdAt;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  @JsonKey(name: "pushed_at")
  DateTime pushedAt;

  @JsonKey(name: "git_url")
  String gitUrl;

  @JsonKey(name: "ssh_url")
  String sshUrl;

  @JsonKey(name: "clone_url")
  String cloneUrl;

  @JsonKey(name: "svn_url")
  String svnUrl;

  @JsonKey(name: "stargazers_count")
  int stargazersCount;

  @JsonKey(name: "watchers_count")
  int watchersCount;

  @JsonKey(name: "forks_count")
  int forksCount;

  @JsonKey(name: "open_issues_count")
  int openIssuesCount;

  @JsonKey(name: "subscribers_count")
  int subscribersCount;

  @JsonKey(name: "private")
  bool private;

  bool fork;
  @JsonKey(name: "has_issues")
  bool hasIssues;
  @JsonKey(name: "has_projects")
  bool hasProjects;

  @JsonKey(name: "has_downloads")
  bool hasDownloads;

  @JsonKey(name: "has_wiki")
  bool hasWiki;

  @JsonKey(name: "has_pages")
  bool hasPages;

  UserBean owner;

  License license;

  Repository parent;

  RepositoryPermissions permissions;

  List<String> topics;

  ///issue总数，不参加序列化
  int allIssueCount;

  Repository(
    this.id,
    this.size,
    this.name,
    this.fullName,
    this.htmlUrl,
    this.description,
    this.language,
    this.license,
    this.defaultBranch,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.gitUrl,
    this.sshUrl,
    this.cloneUrl,
    this.svnUrl,
    this.stargazersCount,
    this.watchersCount,
    this.forksCount,
    this.openIssuesCount,
    this.subscribersCount,
    this.private,
    this.fork,
    this.hasIssues,
    this.hasProjects,
    this.hasDownloads,
    this.hasWiki,
    this.hasPages,
    this.owner,
    this.parent,
    this.permissions,
    this.topics,
    this.stargazers_url,
    this.contributors_url,
    this.subscribers_url,
  );

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);

  Repository.empty();

  @override
  String toString() {
    return 'Repository{id: $id, size: $size, name: $name, fullName: $fullName, htmlUrl: $htmlUrl, description: $description, language: $language, defaultBranch: $defaultBranch, createdAt: $createdAt, updatedAt: $updatedAt, pushedAt: $pushedAt, gitUrl: $gitUrl, sshUrl: $sshUrl, cloneUrl: $cloneUrl, svnUrl: $svnUrl, stargazersCount: $stargazersCount, watchersCount: $watchersCount, forksCount: $forksCount, openIssuesCount: $openIssuesCount, subscribersCount: $subscribersCount, private: $private, fork: $fork, hasIssues: $hasIssues, hasProjects: $hasProjects, hasDownloads: $hasDownloads, hasWiki: $hasWiki, hasPages: $hasPages, owner: $owner, license: $license, parent: $parent, permissions: $permissions, topics: $topics, allIssueCount: $allIssueCount}';
  }
}
