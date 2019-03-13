import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class IssueManager {
  factory IssueManager() => _getInstance();

  static IssueManager get instance => _getInstance();
  static IssueManager _instance;

  IssueManager._internal() {}

  static IssueManager _getInstance() {
    if (_instance == null) {
      _instance = new IssueManager._internal();
    }
    return _instance;
  }

  getIssue(q, state, sort, order, userName, page, Function successCallback, Function errorCallback) {
    String url = Api.getIssue(q, state, sort, order, userName) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }
}
