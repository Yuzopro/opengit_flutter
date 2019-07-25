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
    if (response != null && response.data != null && response.data.length > 0) {
      List<TrendingReposBean> list = new List();
      for (int i = 0; i < response.data.length; i++) {
        var dataItem = response.data[i];
        TrendingReposBean bean = TrendingReposBean.fromJson(dataItem);
        list.add(bean);
      }
      return list;
    }
    return null;
  }

  getUser(String language, String since) async {
    String url = Api.getTrendingUser(language, since);
    final response = await HttpRequest().get(url);
    if (response != null && response.data != null && response.data.length > 0) {
      List<TrendingUserBean> list = new List();
      for (int i = 0; i < response.data.length; i++) {
        var dataItem = response.data[i];
        TrendingUserBean bean = TrendingUserBean.fromJson(dataItem);
        list.add(bean);
      }
      return list;
    }
    return null;
  }

  getLanguage() async {
    String url = Api.getTrendingLanguage();
    final response = await HttpRequest().get(url);
    if (response != null && response.data != null && response.data.length > 0) {
      List<TrendingLanguageBean> list = new List();
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
      return list;
    }
    return null;
  }

//  List<TrendingLanguageBean> test() {
//    List<TrendingLanguageBean> list = new List();
//
//    for (int i = 0; i < 10; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'A$i', letter: 'A');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 9; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'B$i', letter: 'B');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 8; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'C$i', letter: 'C');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 7; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'D$i', letter: 'D');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 6; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'E$i', letter: 'E');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 5; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'F$i', letter: 'F');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 4; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'G$i', letter: 'G');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 3; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'H$i', letter: 'H');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 2; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'I$i', letter: 'I');
//      list.add(item);
//    }
//
//    for (int i = 0; i < 1; i++) {
//      TrendingLanguageBean item = TrendingLanguageBean('', 'J$i', letter: 'J');
//      list.add(item);
//    }
//
//    return list;
//  }
}
