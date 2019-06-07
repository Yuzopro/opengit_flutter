import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/user_bean.dart';

part 'release_bean.g.dart';

@JsonSerializable()
class ReleaseBean {
  int id;
  @JsonKey(name: "tag_name")
  String tagName;
  @JsonKey(name: "target_commitish")
  String targetCommitish;
  String name;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;
  @JsonKey(name: "tarball_url")
  String tarballUrl;
  @JsonKey(name: "zipball_url")
  String zipballUrl;

  bool draft;
  @JsonKey(name: "prerelease")
  bool preRelease;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "published_at")
  DateTime publishedAt;

  UserBean author;
  List<ReleaseAssetBean> assets;

  ReleaseBean(
    this.id,
    this.tagName,
    @JsonKey(name: "target_commitish") this.targetCommitish,
    this.name,
    this.body,
    this.bodyHtml,
    this.tarballUrl,
    this.zipballUrl,
    this.draft,
    this.preRelease,
    this.createdAt,
    this.publishedAt,
    this.author,
    this.assets,
  );

  factory ReleaseBean.fromJson(Map<String, dynamic> json) => _$ReleaseBeanFromJson(json);

  @override
  String toString() {
    return 'ReleaseBean{id: $id, tagName: $tagName, targetCommitish: $targetCommitish, name: $name, body: $body, bodyHtml: $bodyHtml, tarballUrl: $tarballUrl, zipballUrl: $zipballUrl, draft: $draft, preRelease: $preRelease, createdAt: $createdAt, publishedAt: $publishedAt, author: $author, assets: $assets}';
  }
}
