// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juejin_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

juejin_bean _$juejin_beanFromJson(Map<String, dynamic> json) {
  return juejin_bean(
    json['s'] as int,
    json['m'] as String,
    json['d'] == null ? null : D.fromJson(json['d'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$juejin_beanToJson(juejin_bean instance) =>
    <String, dynamic>{
      's': instance.s,
      'm': instance.m,
      'd': instance.d,
    };

D _$DFromJson(Map<String, dynamic> json) {
  return D(
    json['total'] as int,
    (json['entrylist'] as List)
        ?.map((e) =>
            e == null ? null : Entrylist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DToJson(D instance) => <String, dynamic>{
      'total': instance.total,
      'entrylist': instance.entrylist,
    };

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
        ?.map(
            (e) => e == null ? null : Tags.fromJson(e as Map<String, dynamic>))
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
    json['isCollected'] as bool,
  );
}

Map<String, dynamic> _$EntrylistToJson(Entrylist instance) => <String, dynamic>{
      'collectionCount': instance.collectionCount,
      'userRankIndex': instance.userRankIndex,
      'buildTime': instance.buildTime,
      'commentsCount': instance.commentsCount,
      'gfw': instance.gfw,
      'objectId': instance.objectId,
      'checkStatus': instance.checkStatus,
      'isEvent': instance.isEvent,
      'entryView': instance.entryView,
      'subscribersCount': instance.subscribersCount,
      'ngxCachedTime': instance.ngxCachedTime,
      'verifyStatus': instance.verifyStatus,
      'tags': instance.tags,
      'updatedAt': instance.updatedAt,
      'rankIndex': instance.rankIndex,
      'hot': instance.hot,
      'autoPass': instance.autoPass,
      'originalUrl': instance.originalUrl,
      'verifyCreatedAt': instance.verifyCreatedAt,
      'createdAt': instance.createdAt,
      'user': instance.user,
      'author': instance.author,
      'screenshot': instance.screenshot,
      'original': instance.original,
      'hotIndex': instance.hotIndex,
      'content': instance.content,
      'title': instance.title,
      'lastCommentTime': instance.lastCommentTime,
      'type': instance.type,
      'english': instance.english,
      'category': instance.category,
      'viewsCount': instance.viewsCount,
      'summaryInfo': instance.summaryInfo,
      'isCollected': instance.isCollected,
    };

Tags _$TagsFromJson(Map<String, dynamic> json) {
  return Tags(
    json['ngxCachedTime'] as int,
    json['ngxCached'] as bool,
    json['title'] as String,
    json['id'] as String,
  );
}

Map<String, dynamic> _$TagsToJson(Tags instance) => <String, dynamic>{
      'ngxCachedTime': instance.ngxCachedTime,
      'ngxCached': instance.ngxCached,
      'title': instance.title,
      'id': instance.id,
    };

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
    json['objectId'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'community': instance.community,
      'collectedEntriesCount': instance.collectedEntriesCount,
      'company': instance.company,
      'followersCount': instance.followersCount,
      'followeesCount': instance.followeesCount,
      'role': instance.role,
      'postedPostsCount': instance.postedPostsCount,
      'level': instance.level,
      'isAuthor': instance.isAuthor,
      'postedEntriesCount': instance.postedEntriesCount,
      'totalCommentsCount': instance.totalCommentsCount,
      'ngxCachedTime': instance.ngxCachedTime,
      'ngxCached': instance.ngxCached,
      'viewedEntriesCount': instance.viewedEntriesCount,
      'jobTitle': instance.jobTitle,
      'subscribedTagsCount': instance.subscribedTagsCount,
      'totalCollectionsCount': instance.totalCollectionsCount,
      'username': instance.username,
      'avatarLarge': instance.avatarLarge,
      'objectId': instance.objectId,
    };

Community _$CommunityFromJson(Map<String, dynamic> json) {
  return Community(
    json['github'] == null
        ? null
        : Github.fromJson(json['github'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommunityToJson(Community instance) => <String, dynamic>{
      'github': instance.github,
    };

Github _$GithubFromJson(Map<String, dynamic> json) {
  return Github(
    json['username'] as String,
    json['avatarLarge'] as String,
    json['uid'] as String,
  );
}

Map<String, dynamic> _$GithubToJson(Github instance) => <String, dynamic>{
      'username': instance.username,
      'avatarLarge': instance.avatarLarge,
      'uid': instance.uid,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['ngxCached'] as bool,
    json['title'] as String,
    json['id'] as String,
    json['name'] as String,
    json['ngxCachedTime'] as int,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'ngxCached': instance.ngxCached,
      'title': instance.title,
      'id': instance.id,
      'name': instance.name,
      'ngxCachedTime': instance.ngxCachedTime,
    };
