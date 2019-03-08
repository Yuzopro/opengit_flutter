import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class ReposManager {
  factory ReposManager() => _getInstance();

  static ReposManager get instance => _getInstance();
  static ReposManager _instance;

  ReposManager._internal() {}

  static ReposManager _getInstance() {
    if (_instance == null) {
      _instance = new ReposManager._internal();
    }
    return _instance;
  }

  getUserRepos(String userName, int page, String sort, Function successCallback,
      Function errorCallback) {
    String url = Api.userRepos(userName, sort) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  getReposDetail(
      reposOwner, reposName, Function successCallback, Function errorCallback) {
    String url = Api.getReposDetail(reposOwner, reposName);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  void getReadme(
      reposFullName, branch, Function successCallback, Function errorCallback) {
    String url = Api.readmeFile(reposFullName, branch);
    HttpManager.doGet(url, {"Accept": 'application/vnd.github.VERSION.raw'},
        successCallback, errorCallback);
  }

  void getReposStar(
      reposOwner, reposName, Function successCallback, Function errorCallback) {
    String url = Api.getReposStar(reposOwner, reposName);
    HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  void getReposWatcher(
      reposOwner, reposName, Function successCallback, Function errorCallback) {
    String url = Api.getReposWatcher(reposOwner, reposName);
    HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  void doReposStarAction(reposOwner, reposName, bool isEnable,
      Function successCallback, Function errorCallback) {
    String url = Api.getReposStar(reposOwner, reposName);
    if (isEnable) {
      HttpManager.doDelete(url, successCallback, errorCallback);
    } else {
      HttpManager.doPut(url, successCallback, errorCallback);
    }
  }

  void doRepossWatcherAction(reposOwner, reposName, bool isEnable,
      Function successCallback, Function errorCallback) {
    String url = Api.getReposWatcher(reposOwner, reposName);
    if (isEnable) {
      HttpManager.doDelete(url, successCallback, errorCallback);
    } else {
      HttpManager.doPut(url, successCallback, errorCallback);
    }
  }

  void getReposEvents(reposOwner, reposName, page, Function successCallback,
      Function errorCallback) {
    String url = Api.getReposEvents(reposOwner, reposName) +
        Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  void getBranches(
      reposOwner, reposName, Function successCallback, Function errorCallback) {
    String url = Api.getBranches(reposOwner, reposName);
    HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  getTrending(
      since, languageType, Function successCallback, Function errorCallback) {
    String url = Api.getTrending(since, languageType);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }
}
