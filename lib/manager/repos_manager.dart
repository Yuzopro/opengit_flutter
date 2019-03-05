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

  getUserRepos(String userName, int page, String sort,
      Function successCallback,
      Function errorCallback) {
    String url = Api.userRepos(userName, sort) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, successCallback, errorCallback);
  }
}