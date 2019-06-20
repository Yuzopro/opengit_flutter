// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juejin_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

juejin_bean _$juejin_beanFromJson(Map<String, dynamic> json) {
  return juejin_bean(json['s'] as int, json['m'] as String,
      json['d'] == null ? null : D.fromJson(json['d'] as Map<String, dynamic>));
}

D _$DFromJson(Map<String, dynamic> json) {
  return D(
      json['total'] as int,
      (json['entrylist'] as List)
          ?.map((e) =>
              e == null ? null : Entrylist.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Entrylist _$EntrylistFromJson(Map<String, dynamic> json) {
  return Entrylist(
      json['collectionCount'] as int,
      (json['userRankIndex'] as num)?.toDouble(),
      (json['buildTime'] as num)?.toDouble(),
      json['commentsCount'] as int,
      json['gfw'] as bool,
      json['objectId'] as String,
      json['checkStatus'] as bool,
      json['isEvent'] as bool,
      json['entryView'] as String,
      json['subscribersCount'] as int,
      json['ngxCachedTime'] as int,
      json['verifyStatus'] as bool,
      (json['tags'] as List)
          ?.map((e) =>
              e == null ? null : Tags.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['updatedAt'] as String,
      (json['rankIndex'] as num)?.toDouble(),
      json['hot'] as bool,
      json['autoPass'] as bool,
      json['originalUrl'] as String,
      json['verifyCreatedAt'] as String,
      json['createdAt'] as String,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['author'] as String,
      json['screenshot'] as String,
      json['original'] as bool,
      (json['hotIndex'] as num)?.toDouble(),
      json['content'] as String,
      json['title'] as String,
      json['lastCommentTime'] as String,
      json['type'] as String,
      json['english'] as bool,
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['viewsCount'] as int,
      json['summaryInfo'] as String,
      json['isCollected'] as bool);
}

Tags _$TagsFromJson(Map<String, dynamic> json) {
  return Tags(json['ngxCachedTime'] as int, json['ngxCached'] as bool,
      json['title'] as String, json['id'] as String);
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['community'] == null
          ? null
          : Community.fromJson(json['community'] as Map<String, dynamic>),
      json['collectedEntriesCount'] as int,
      json['company'] as String,
      json['followersCount'] as int,
      json['followeesCount'] as int,
      json['role'] as String,
      json['postedPostsCount'] as int,
      json['level'] as int,
      json['isAuthor'] as bool,
      json['postedEntriesCount'] as int,
      json['totalCommentsCount'] as int,
      json['ngxCachedTime'] as int,
      json['ngxCached'] as bool,
      json['viewedEntriesCount'] as int,
      json['jobTitle'] as String,
      json['subscribedTagsCount'] as int,
      json['totalCollectionsCount'] as int,
      json['username'] as String,
      json['avatarLarge'] as String,
      json['objectId'] as String);
}

Community _$CommunityFromJson(Map<String, dynamic> json) {
  return Community(json['github'] == null
      ? null
      : Github.fromJson(json['github'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CommunityToJson(Community instance) =>
    <String, dynamic>{'github': instance.github};

Github _$GithubFromJson(Map<String, dynamic> json) {
  return Github(json['username'] as String, json['avatarLarge'] as String,
      json['uid'] as String);
}

Map<String, dynamic> _$GithubToJson(Github instance) => <String, dynamic>{
      'username': instance.username,
      'avatarLarge': instance.avatarLarge,
      'uid': instance.uid
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      json['ngxCached'] as bool,
      json['title'] as String,
      json['id'] as String,
      json['name'] as String,
      json['ngxCachedTime'] as int);
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'ngxCached': instance.ngxCached,
      'title': instance.title,
      'id': instance.id,
      'name': instance.name,
      'ngxCachedTime': instance.ngxCachedTime
    };
