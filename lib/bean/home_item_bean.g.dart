// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_item_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeItemBean _$HomeItemBeanFromJson(Map<String, dynamic> json) {
  return HomeItemBean(
    (json['recommend'] as List)
        ?.map((e) =>
            e == null ? null : HomeItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['other'] as List)
        ?.map((e) =>
            e == null ? null : HomeItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HomeItemBeanToJson(HomeItemBean instance) =>
    <String, dynamic>{
      'recommend': instance.recommend,
      'other': instance.other,
    };

HomeItem _$HomeItemFromJson(Map<String, dynamic> json) {
  return HomeItem(
    json['title'] as String,
    json['subTitle'] as String,
    json['tag'] as String,
    json['image'] as String,
    json['name'] as String,
    json['repo'] as String,
    json['url'] as String,
    json['type'] as int,
  );
}

Map<String, dynamic> _$HomeItemToJson(HomeItem instance) => <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'tag': instance.tag,
      'image': instance.image,
      'name': instance.name,
      'repo': instance.repo,
      'url': instance.url,
      'type': instance.type,
    };
