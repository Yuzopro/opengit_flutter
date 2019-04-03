import 'package:json_annotation/json_annotation.dart';

part 'reaction_bean.g.dart';


@JsonSerializable()
class ReactionBean extends Object {

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'total_count')
  int totalCount;

  @JsonKey(name: '+1')
  int like;

  @JsonKey(name: '-1')
  int noLike;

  @JsonKey(name: 'laugh')
  int laugh;

  @JsonKey(name: 'hooray')
  int hooray;

  @JsonKey(name: 'confused')
  int confused;

  @JsonKey(name: 'heart')
  int heart;

  @JsonKey(name: 'rocket')
  int rocket;

  @JsonKey(name: 'eyes')
  int eyes;

  ReactionBean(this.url,this.totalCount,this.like,this.noLike,this.laugh,this.hooray,this.confused,this.heart,this.rocket,this.eyes,);

  factory ReactionBean.fromJson(Map<String, dynamic> srcJson) => _$ReactionBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReactionBeanToJson(this);

  @override
  String toString() {
    return 'ReactionBean{totalCount: $totalCount, like: $like, noLike: $noLike, laugh: $laugh, hooray: $hooray, confused: $confused, heart: $heart, rocket: $rocket, eyes: $eyes}';
  }

}