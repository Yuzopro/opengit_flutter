import 'package:json_annotation/json_annotation.dart';
import 'package:open_git/bean/user_bean.dart';

part 'reaction_detail_bean.g.dart';

@JsonSerializable()
class ReactionDetailBean extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'node_id')
  String nodeId;

  @JsonKey(name: 'user')
  UserBean user;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  ReactionDetailBean(
    this.id,
    this.nodeId,
    this.user,
    this.content,
    this.createdAt,
  );

  factory ReactionDetailBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ReactionDetailBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReactionDetailBeanToJson(this);

  @override
  String toString() {
    return 'ReactionDetailBean{id: $id, nodeId: $nodeId, user: $user, content: $content, createdAt: $createdAt}';
  }
}
