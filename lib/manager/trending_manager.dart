import 'package:open_git/bean/trending_language_bean.dart';
import 'package:open_git/bean/trending_repos_bean.dart';
import 'package:open_git/bean/trending_user_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';

class TrendingManager {
  factory TrendingManager() => _getInstance();

  static TrendingManager get instance => _getInstance();
  static TrendingManager _instance;

  TrendingManager._internal();

  static TrendingManager _getInstance() {
    if (_instance == null) {
      _instance = TrendingManager._internal();
    }
    return _instance;
  }

  getRepos(String language, String since) async {
    String url = Api.getTrendingRepos(language, since);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<TrendingReposBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          TrendingReposBean bean = TrendingReposBean.fromJson(dataItem);
          list.add(bean);
        }
      }
      return list;
    }
    return null;
  }

  getUser(String language, String since) async {
    String url = Api.getTrendingUser(language, since);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<TrendingUserBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          TrendingUserBean bean = TrendingUserBean.fromJson(dataItem);
          list.add(bean);
        }
      }
      return list;
    }
    return null;
  }

  getLanguage() async {
    String url = Api.getTrendingLanguage();
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<TrendingLanguageBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          TrendingLanguageBean bean = TrendingLanguageBean.fromJson(dataItem);
          String letter = bean.name.substring(0, 1).toUpperCase();
          if (!RegExp("[A-Z]").hasMatch(letter)) {
            letter = '#';
          }
          bean.letter = letter;
          list.add(bean);
        }
      }
      return list;
    }
    return null;
  }
}
