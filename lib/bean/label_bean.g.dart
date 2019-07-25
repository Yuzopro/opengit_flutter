// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Labels _$LabelsFromJson(Map<String, dynamic> json) {
  return Labels(
    json['id'] as int,
    json['node_id'] as String,
    json['url'] as String,
    json['name'] as String,
    json['description'] as String,
    json['color'] as String,
    json['default'] as bool,
  );
}

Map<String, dynamic> _$LabelsToJson(Labels instance) => <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'url': instance.url,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'default': instance.default_,
    };
