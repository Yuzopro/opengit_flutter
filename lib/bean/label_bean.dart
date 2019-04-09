import 'package:json_annotation/json_annotation.dart';

part 'label_bean.g.dart';

@JsonSerializable()
class Labels extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'node_id')
  String nodeId;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'color')
  String color;

  @JsonKey(name: 'default')
  bool default_;

  Labels(
    this.id,
    this.nodeId,
    this.url,
    this.name,
    this.description,
    this.color,
    this.default_,
  );

  factory Labels.fromJson(Map<String, dynamic> srcJson) =>
      _$LabelsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LabelsToJson(this);
}
