import 'package:json_annotation/json_annotation.dart';

part 'login_bean.g.dart';

@JsonSerializable()
class LoginBean {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'app')
  App app;

  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'hashed_token')
  String hashedToken;

  @JsonKey(name: 'token_last_eight')
  String tokenLastEight;

  @JsonKey(name: 'note')
  String note;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'scopes')
  List<String> scopes;

  LoginBean(
    this.id,
    this.url,
    this.app,
    this.token,
    this.hashedToken,
    this.tokenLastEight,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.scopes,
  );

  factory LoginBean.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginBeanFromJson(srcJson);
}

@JsonSerializable()
class App {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'client_id')
  String clientId;

  App(
    this.name,
    this.url,
    this.clientId,
  );

  factory App.fromJson(Map<String, dynamic> srcJson) => _$AppFromJson(srcJson);
}
