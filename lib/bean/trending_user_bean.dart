import 'package:json_annotation/json_annotation.dart';

part 'trending_user_bean.g.dart';

List<TrendingUserBean> getTrendingUserBeanList(List<dynamic> list) {
  List<TrendingUserBean> result = [];
  list.forEach((item) {
    result.add(TrendingUserBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class TrendingUserBean extends Object {
  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'repo')
  Repo repo;

  TrendingUserBean(
    this.username,
    this.name,
    this.type,
    this.url,
    this.avatar,
    this.repo,
  );

  factory TrendingUserBean.fromJson(Map<String, dynamic> srcJson) =>
      _$TrendingUserBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TrendingUserBeanToJson(this);

  @override
  String toString() {
    return 'TrendingUserBean{username: $username, name: $name, type: $type, url: $url, avatar: $avatar, repo: $repo}';
  }
}

@JsonSerializable()
class Repo extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'url')
  String url;

  Repo(
    this.name,
    this.description,
    this.url,
  );

  factory Repo.fromJson(Map<String, dynamic> srcJson) =>
      _$RepoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RepoToJson(this);

  @override
  String toString() {
    return 'Repo{name: $name, description: $description, url: $url}';
  }
}
