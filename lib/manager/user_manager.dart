import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class UserManager {
  factory UserManager() => _getInstance();

  static UserManager get instance => _getInstance();
  static UserManager _instance;

  UserManager._internal() {}

  static UserManager _getInstance() {
    if (_instance == null) {
      _instance = new UserManager._internal();
    }
    return _instance;
  }

  getUserRepos(String userName, int page, String sort, bool isStar,
      Function successCallback, Function errorCallback) {
    String url;
    if (isStar) {
      url = Api.userStar(userName, null);
    } else {
      url = Api.userRepos(userName, sort);
    }
    url += Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  getUserFollower(String userName, int page, Function successCallback,
      Function errorCallback) {
    String url = Api.getUserFollower(userName) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  getUserFollowing(String userName, int page, Function successCallback,
      Function errorCallback) {
    String url = Api.getUserFollowing(userName) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }
}
