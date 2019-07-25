import 'package:json_annotation/json_annotation.dart';

part 'trending_repos_bean.g.dart';

List<TrendingReposBean> getTrendingReposBeanList(List<dynamic> list) {
  List<TrendingReposBean> result = [];
  list.forEach((item) {
    result.add(TrendingReposBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class TrendingReposBean extends Object {
  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'language')
  String language;

  @JsonKey(name: 'languageColor')
  String languageColor;

  @JsonKey(name: 'stars')
  int stars;

  @JsonKey(name: 'forks')
  int forks;

  @JsonKey(name: 'currentPeriodStars')
  int currentPeriodStars;

  @JsonKey(name: 'builtBy')
  List<BuiltBy> builtBy;

  TrendingReposBean(
    this.author,
    this.name,
    this.avatar,
    this.url,
    this.description,
    this.language,
    this.languageColor,
    this.stars,
    this.forks,
    this.currentPeriodStars,
    this.builtBy,
  );

  factory TrendingReposBean.fromJson(Map<String, dynamic> srcJson) =>
      _$TrendingReposBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TrendingReposBeanToJson(this);

  @override
  String toString() {
    return 'TrendingReposBean{author: $author, name: $name, avatar: $avatar, url: $url, description: $description, language: $language, languageColor: $languageColor, stars: $stars, forks: $forks, currentPeriodStars: $currentPeriodStars, builtBy: $builtBy}';
  }
}

@JsonSerializable()
class BuiltBy extends Object {
  @JsonKey(name: 'href')
  String href;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'username')
  String username;

  BuiltBy(
    this.href,
    this.avatar,
    this.username,
  );

  factory BuiltBy.fromJson(Map<String, dynamic> srcJson) =>
      _$BuiltByFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BuiltByToJson(this);

  @override
  String toString() {
    return 'BuiltBy{href: $href, avatar: $avatar, username: $username}';
  }
}
