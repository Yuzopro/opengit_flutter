import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/user_bean.dart';

part 'release_asset_bean.g.dart';

@JsonSerializable()
class ReleaseAssetBean {
  int id;
  String name;
  String label;
  UserBean uploader;
  @JsonKey(name: "content_type")
  String contentType;
  String state;
  int size;
  int downloadCout;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "browser_download_url")
  String downloadUrl;

  ReleaseAssetBean(
    this.id,
    this.name,
    this.label,
    this.uploader,
    this.contentType,
    this.state,
    this.size,
    this.downloadCout,
    this.createdAt,
    this.updatedAt,
    this.downloadUrl,
  );

  factory ReleaseAssetBean.fromJson(Map<String, dynamic> json) => _$ReleaseAssetBeanFromJson(json);
}
