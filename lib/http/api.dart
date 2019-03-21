import 'package:open_git/common/config.dart';

class Api {
  static const String _BASE_URL = "https://api.github.com/";

  static String authorizations() {
    return "${_BASE_URL}authorizations";
  }

  ///我的用户信息 get
  static getMyUserInfo() {
    return "${_BASE_URL}user";
  }

  ///用户的仓库 get
  static userRepos(userName, sort) {
    sort ??= 'pushed';
    return "${_BASE_URL}users/$userName/repos?sort=$sort";
  }

  //仓库详情 get
  static getReposDetail(reposOwner, reposName) {
    return "${_BASE_URL}repos/$reposOwner/$reposName";
  }

  //仓库Star get
  static getReposStar(reposOwner, reposName) {
    return "${_BASE_URL}user/starred/$reposOwner/$reposName";
  }

  //仓库Watch get
  static getReposWatcher(reposOwner, reposName) {
    return "${_BASE_URL}user/subscriptions/$reposOwner/$reposName";
  }

  ///README 文件地址 get
  static readmeFile(reposNameFullName, curBranch) {
    return "${_BASE_URL}repos/" +
        reposNameFullName +
        "/" +
        "readme" +
        ((curBranch == null) ? "" : ("?ref=" + curBranch));
  }

  //仓库动态 get
  static getReposEvents(reposOwner, reposName) {
    return "${_BASE_URL}networks/$reposOwner/$reposName/events?";
  }

  //仓库分支
  static getBranches(reposOwner, reposName) {
    return "${_BASE_URL}repos/$reposOwner/$reposName/branches";
  }

  //趋势 get
  static getTrending(since, languageType) {
    if (languageType != null) {
      return "https://github.com/trending/$languageType?since=$since";
    }
    return "https://github.com/trending?since=$since";
  }

  //用户收到的事件信息 get
  static getEventReceived(userName) {
    return "${_BASE_URL}users/$userName/received_events?";
  }

  //用户相关的事件信息 get
  static getEvent(userName) {
    return "${_BASE_URL}users/$userName/events?";
  }

  //获取用户问题列表
  static getIssue(q, state, sort, order, userName) {
    return "${_BASE_URL}search/issues?q=$q:$userName+state:$state&sort=$sort&order=$order";
  }
  
  //获取语言类型star列表
  static getLanguages(language) {
    return "${_BASE_URL}search/repositories?q=language:$language&sort=stars";
  }

  //用户的star get
  static userStar(userName, sort) {
    sort ??= 'updated';

    return "${_BASE_URL}users/$userName/starred?sort=$sort";
  }

  //我的关注者 get
  static getUserFollowing(userName) {
    return "${_BASE_URL}users/$userName/following?";
  }

  //关注我的 get
  static getUserFollower(userName) {
    return "${_BASE_URL}users/$userName/followers?";
  }

  //仓库路径下的内容 get
  static reposDataDir(reposOwner, repos, path, [branch = 'master']) {
    return "${_BASE_URL}repos/$reposOwner/$repos/contents$path" + ((branch == null) ? "" : ("?ref=" + branch));
  }

  //搜索
  static search(type, query) {
    return "${_BASE_URL}search/$type?q=$query";
  }

  //处理分页参数
  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page=$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }
}
