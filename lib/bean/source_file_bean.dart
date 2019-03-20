import 'package:json_annotation/json_annotation.dart';

part 'source_file_bean.g.dart';

@JsonSerializable()
class SourceFileBean {
  String name;
  String path;
  String sha;
  int size;
  String url;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "git_url")
  String gitUrl;
  @JsonKey(name: "download_url")
  String downloadUrl;
  @JsonKey(name: "type")
  String type;

  SourceFileBean(
    this.name,
    this.path,
    this.sha,
    this.size,
    this.url,
    this.htmlUrl,
    this.gitUrl,
    this.downloadUrl,
    this.type,
  );

  factory SourceFileBean.fromJson(Map<String, dynamic> json) => _$SourceFileBeanFromJson(json);

  Map<String, dynamic> toJson() => _$SourceFileBeanToJson(this);

  @override
  String toString() {
    return 'SourceFileBean{name: $name, path: $path, url: $url, htmlUrl: $htmlUrl}';
  }


}
