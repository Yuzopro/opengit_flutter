import 'package:open_git/common/config.dart';

class Api {
  static const String _BASE_URL = "https://api.github.com/";

  static String authorizations() {
    return "${_BASE_URL}authorizations";
  }

  ///我的用户信息 GET
  static getMyUserInfo() {
    return "${_BASE_URL}user";
  }

  ///用户的仓库 get
  static userRepos(userName, sort) {
    sort ??= 'pushed';
    return "${_BASE_URL}users/$userName/repos?sort=$sort";
  }

  ///处理分页参数
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