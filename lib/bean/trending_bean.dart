import 'package:json_annotation/json_annotation.dart';

part 'trending_bean.g.dart';

@JsonSerializable()
class TrendingBean {
  String fullName;
  String url;

  String description;
  String language;
  String meta;
  List<String> contributors;
  String contributorsUrl;

  String starCount;
  String forkCount;
  String name;

  String reposName;

  TrendingBean(
    this.fullName,
    this.url,
    this.description,
    this.language,
    this.meta,
    this.contributors,
    this.contributorsUrl,
    this.starCount,
    this.name,
    this.reposName,
    this.forkCount,
  );

  TrendingBean.empty();

  factory TrendingBean.fromJson(Map<String, dynamic> json) => _$TrendingBeanFromJson(json);

  @override
  String toString() {
    return 'TrendingBean{fullName: $fullName, url: $url, description: $description, language: $language, meta: $meta, contributors: $contributors, contributorsUrl: $contributorsUrl, starCount: $starCount, forkCount: $forkCount, name: $name, reposName: $reposName}';
  }
}
