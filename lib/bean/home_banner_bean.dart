import 'package:json_annotation/json_annotation.dart';

part 'home_banner_bean.g.dart';

@JsonSerializable()
class HomeBannerBean extends Object {
  List<Data> data;

  int errorCode;

  String errorMsg;

  HomeBannerBean(
    this.data,
    this.errorCode,
    this.errorMsg,
  );

  factory HomeBannerBean.fromJson(Map<String, dynamic> srcJson) =>
      _$HomeBannerBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HomeBannerBeanToJson(this);
}

@JsonSerializable()
class Data extends Object {
  String desc;

  int id;

  String imagePath;

  int isVisible;

  int order;

  String title;

  int type;

  String url;

  Data(
    this.desc,
    this.id,
    this.imagePath,
    this.isVisible,
    this.order,
    this.title,
    this.type,
    this.url,
  );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
