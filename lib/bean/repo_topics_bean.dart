import 'package:json_annotation/json_annotation.dart';

part 'repo_topics_bean.g.dart';

@JsonSerializable()
class RepoTopicsBean extends Object {
  @JsonKey(name: 'names')
  List<String> names;

  RepoTopicsBean(
    this.names,
  );

  factory RepoTopicsBean.fromJson(Map<String, dynamic> srcJson) =>
      _$RepoTopicsBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RepoTopicsBeanToJson(this);
}
