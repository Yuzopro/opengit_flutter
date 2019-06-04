import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';
import 'package:open_git/util/markdown_util.dart';

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

  Future<List<Repository>> getUserRepos(
      String userName, int page, String sort, bool isStar) async {
    String url;
    if (isStar) {
      url = Api.userStar(userName, null);
    } else {
      url = Api.userRepos(userName, sort);
    }
    url += Api.getPageParams("&", page);
    final response = await HttpManager.doGet(url, null);
    if (response != null && response.data != null && response.data.length > 0) {
      List<Repository> list = new List();
      for (int i = 0; i < response.data.length; i++) {
        var dataItem = response.data[i];
        Repository repository = Repository.fromJson(dataItem);
        repository.description =
            MarkdownUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
//        repository.description = repository.description ?? "暂无描述";
        list.add(repository);
      }
      return list;
    }
    return null;
  }

  Future<List<UserBean>> getUserFollower(String userName, int page) async {
    String url = Api.getUserFollower(userName) + Api.getPageParams("&", page);
    final response = await HttpManager.doGet(url, null);
    if (response != null && response.data != null && response.data.length > 0) {
      List<UserBean> list = new List();
      for (int i = 0; i < response.data.length; i++) {
        var dataItem = response.data[i];
        list.add(UserBean.fromJson(dataItem));
      }
      return list;
    }
    return null;
  }

  Future<List<UserBean>> getUserFollowing(String userName, int page) async {
    String url = Api.getUserFollowing(userName) + Api.getPageParams("&", page);
    final response = await HttpManager.doGet(url, null);
    if (response != null && response.data != null && response.data.length > 0) {
      List<UserBean> list = new List();
      for (int i = 0; i < response.data.length; i++) {
        var dataItem = response.data[i];
        list.add(UserBean.fromJson(dataItem));
      }
      return list;
    }
    return null;
  }
}
