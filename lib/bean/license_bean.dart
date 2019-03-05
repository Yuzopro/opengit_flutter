import 'package:json_annotation/json_annotation.dart';

part 'license_bean.g.dart';

@JsonSerializable()
class License {

  String name;

  License(this.name);

  factory License.fromJson(Map<String, dynamic> json) => _$LicenseFromJson(json);
}
