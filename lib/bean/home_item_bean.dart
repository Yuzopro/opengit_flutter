import 'package:json_annotation/json_annotation.dart';

part 'home_item_bean.g.dart';

@JsonSerializable()
class HomeItemBean extends Object {
  List<HomeItem> recommend;

  List<HomeItem> other;

  HomeItemBean(
    this.recommend,
    this.other,
  );

  factory HomeItemBean.fromJson(Map<String, dynamic> srcJson) =>
      _$HomeItemBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HomeItemBeanToJson(this);
}

@JsonSerializable()
class HomeItem extends Object {
  String title;

  String subTitle;

  String tag;

  String image;

  String name;

  String repo;

  String url;

  int type; // 1 仓库详情；2 url； 3 掘金flutter列表； 4 个人资料页

  HomeItem(
    this.title,
    this.subTitle,
    this.tag,
    this.image,
    this.name,
    this.repo,
    this.url,
    this.type,
  );

  factory HomeItem.fromJson(Map<String, dynamic> srcJson) =>
      _$HomeItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HomeItemToJson(this);
}
