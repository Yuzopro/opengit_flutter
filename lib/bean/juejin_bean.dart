import 'package:json_annotation/json_annotation.dart';

part 'juejin_bean.g.dart';

@JsonSerializable()
class juejin_bean extends Object {
  @JsonKey(name: 's')
  int s;

  @JsonKey(name: 'm')
  String m;

  @JsonKey(name: 'd')
  D d;

  juejin_bean(
    this.s,
    this.m,
    this.d,
  );

  factory juejin_bean.fromJson(Map<String, dynamic> srcJson) =>
      _$juejin_beanFromJson(srcJson);
}

@JsonSerializable()
class D extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'entrylist')
  List<Entrylist> entrylist;

  D(
    this.total,
    this.entrylist,
  );

  factory D.fromJson(Map<String, dynamic> srcJson) => _$DFromJson(srcJson);
}

@JsonSerializable()
class Entrylist extends Object {
  @JsonKey(name: 'collectionCount')
  int collectionCount;

  @JsonKey(name: 'userRankIndex')
  double userRankIndex;

  @JsonKey(name: 'buildTime')
  double buildTime;

  @JsonKey(name: 'commentsCount')
  int commentsCount;

  @JsonKey(name: 'gfw')
  bool gfw;

  @JsonKey(name: 'objectId')
  String objectId;

  @JsonKey(name: 'checkStatus')
  bool checkStatus;

  @JsonKey(name: 'isEvent')
  bool isEvent;

  @JsonKey(name: 'entryView')
  String entryView;

  @JsonKey(name: 'subscribersCount')
  int subscribersCount;

  @JsonKey(name: 'ngxCachedTime')
  int ngxCachedTime;

  @JsonKey(name: 'verifyStatus')
  bool verifyStatus;

  @JsonKey(name: 'tags')
  List<Tags> tags;

  @JsonKey(name: 'updatedAt')
  String updatedAt;

  @JsonKey(name: 'rankIndex')
  double rankIndex;

  @JsonKey(name: 'hot')
  bool hot;

  @JsonKey(name: 'autoPass')
  bool autoPass;

  @JsonKey(name: 'originalUrl')
  String originalUrl;

  @JsonKey(name: 'verifyCreatedAt')
  String verifyCreatedAt;

  @JsonKey(name: 'createdAt')
  String createdAt;

  @JsonKey(name: 'user')
  User user;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'screenshot')
  String screenshot;

  @JsonKey(name: 'original')
  bool original;

  @JsonKey(name: 'hotIndex')
  double hotIndex;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'lastCommentTime')
  String lastCommentTime;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'english')
  bool english;

  @JsonKey(name: 'category')
  Category category;

  @JsonKey(name: 'viewsCount')
  int viewsCount;

  @JsonKey(name: 'summaryInfo')
  String summaryInfo;

  @JsonKey(name: 'isCollected')
  bool isCollected;

  Entrylist(
    this.collectionCount,
    this.userRankIndex,
    this.buildTime,
    this.commentsCount,
    this.gfw,
    this.objectId,
    this.checkStatus,
    this.isEvent,
    this.entryView,
    this.subscribersCount,
    this.ngxCachedTime,
    this.verifyStatus,
    this.tags,
    this.updatedAt,
    this.rankIndex,
    this.hot,
    this.autoPass,
    this.originalUrl,
    this.verifyCreatedAt,
    this.createdAt,
    this.user,
    this.author,
    this.screenshot,
    this.original,
    this.hotIndex,
    this.content,
    this.title,
    this.lastCommentTime,
    this.type,
    this.english,
    this.category,
    this.viewsCount,
    this.summaryInfo,
    this.isCollected,
  );

  factory Entrylist.fromJson(Map<String, dynamic> srcJson) =>
      _$EntrylistFromJson(srcJson);

  @override
  String toString() {
    return 'Entrylist{collectionCount: $collectionCount, userRankIndex: $userRankIndex, buildTime: $buildTime, commentsCount: $commentsCount, gfw: $gfw, objectId: $objectId, checkStatus: $checkStatus, isEvent: $isEvent, entryView: $entryView, subscribersCount: $subscribersCount, ngxCachedTime: $ngxCachedTime, verifyStatus: $verifyStatus, tags: $tags, updatedAt: $updatedAt, rankIndex: $rankIndex, hot: $hot, autoPass: $autoPass, originalUrl: $originalUrl, verifyCreatedAt: $verifyCreatedAt, createdAt: $createdAt, user: $user, author: $author, screenshot: $screenshot, original: $original, hotIndex: $hotIndex, content: $content, title: $title, lastCommentTime: $lastCommentTime, type: $type, english: $english, category: $category, viewsCount: $viewsCount, summaryInfo: $summaryInfo, isCollected: $isCollected}';
  }
}

@JsonSerializable()
class Tags extends Object {
  @JsonKey(name: 'ngxCachedTime')
  int ngxCachedTime;

  @JsonKey(name: 'ngxCached')
  bool ngxCached;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'id')
  String id;

  Tags(
    this.ngxCachedTime,
    this.ngxCached,
    this.title,
    this.id,
  );

  factory Tags.fromJson(Map<String, dynamic> srcJson) =>
      _$TagsFromJson(srcJson);
}

@JsonSerializable()
class User extends Object {
  @JsonKey(name: 'community')
  Community community;

  @JsonKey(name: 'collectedEntriesCount')
  int collectedEntriesCount;

  @JsonKey(name: 'company')
  String company;

  @JsonKey(name: 'followersCount')
  int followersCount;

  @JsonKey(name: 'followeesCount')
  int followeesCount;

  @JsonKey(name: 'role')
  String role;

  @JsonKey(name: 'postedPostsCount')
  int postedPostsCount;

  @JsonKey(name: 'level')
  int level;

  @JsonKey(name: 'isAuthor')
  bool isAuthor;

  @JsonKey(name: 'postedEntriesCount')
  int postedEntriesCount;

  @JsonKey(name: 'totalCommentsCount')
  int totalCommentsCount;

  @JsonKey(name: 'ngxCachedTime')
  int ngxCachedTime;

  @JsonKey(name: 'ngxCached')
  bool ngxCached;

  @JsonKey(name: 'viewedEntriesCount')
  int viewedEntriesCount;

  @JsonKey(name: 'jobTitle')
  String jobTitle;

  @JsonKey(name: 'subscribedTagsCount')
  int subscribedTagsCount;

  @JsonKey(name: 'totalCollectionsCount')
  int totalCollectionsCount;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'avatarLarge')
  String avatarLarge;

  @JsonKey(name: 'objectId')
  String objectId;

  User(
    this.community,
    this.collectedEntriesCount,
    this.company,
    this.followersCount,
    this.followeesCount,
    this.role,
    this.postedPostsCount,
    this.level,
    this.isAuthor,
    this.postedEntriesCount,
    this.totalCommentsCount,
    this.ngxCachedTime,
    this.ngxCached,
    this.viewedEntriesCount,
    this.jobTitle,
    this.subscribedTagsCount,
    this.totalCollectionsCount,
    this.username,
    this.avatarLarge,
    this.objectId,
  );

  factory User.fromJson(Map<String, dynamic> srcJson) =>
      _$UserFromJson(srcJson);
}

@JsonSerializable()
class Community extends Object {
  @JsonKey(name: 'github')
  Github github;

  Community(
    this.github,
  );

  factory Community.fromJson(Map<String, dynamic> srcJson) =>
      _$CommunityFromJson(srcJson);
}

@JsonSerializable()
class Github extends Object {
  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'avatarLarge')
  String avatarLarge;

  @JsonKey(name: 'uid')
  String uid;

  Github(
    this.username,
    this.avatarLarge,
    this.uid,
  );

  factory Github.fromJson(Map<String, dynamic> srcJson) =>
      _$GithubFromJson(srcJson);
}

@JsonSerializable()
class Category extends Object {
  @JsonKey(name: 'ngxCached')
  bool ngxCached;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'ngxCachedTime')
  int ngxCachedTime;

  Category(
    this.ngxCached,
    this.title,
    this.id,
    this.name,
    this.ngxCachedTime,
  );

  factory Category.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryFromJson(srcJson);
}
