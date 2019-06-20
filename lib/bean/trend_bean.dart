import 'package:json_annotation/json_annotation.dart';

part 'trend_bean.g.dart';

@JsonSerializable()
class TrendBean {
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

  TrendBean(
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

  TrendBean.empty();

  factory TrendBean.fromJson(Map<String, dynamic> json) => _$TrendBeanFromJson(json);

  @override
  String toString() {
    return 'TrendBean{fullName: $fullName, url: $url, description: $description, language: $language, meta: $meta, contributors: $contributors, contributorsUrl: $contributorsUrl, starCount: $starCount, forkCount: $forkCount, name: $name, reposName: $reposName}';
  }
}
