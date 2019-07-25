import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';

class SearchManager {
  factory SearchManager() => _getInstance();

  static SearchManager get instance => _getInstance();
  static SearchManager _instance;

  SearchManager._internal();

  static SearchManager _getInstance() {
    if (_instance == null) {
      _instance = new SearchManager._internal();
    }
    return _instance;
  }

  getIssue(
      type, query, page) async {
    String url = Api.search(type, query) + Api.getPageParams("&", page);
    return await HttpRequest().get(url);
  }
}
