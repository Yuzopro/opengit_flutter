import 'package:json_annotation/json_annotation.dart';

part 'trending_language_bean.g.dart';

List<TrendingLanguageBean> getTrendingLanguageBeanList(List<dynamic> list) {
  List<TrendingLanguageBean> result = [];
  list.forEach((item) {
    result.add(TrendingLanguageBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class TrendingLanguageBean extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  String letter;

  bool isShowLetter;

  TrendingLanguageBean(this.id, this.name, {this.letter});

  factory TrendingLanguageBean.fromJson(Map<String, dynamic> srcJson) =>
      _$TrendingLanguageBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TrendingLanguageBeanToJson(this);
}
