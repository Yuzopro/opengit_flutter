import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/org_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';
import 'package:open_git/manager/login_manager.dart';

class UserManager {
  factory UserManager() => _getInstance();

  static UserManager get instance => _getInstance();
  static UserManager _instance;

  UserManager._internal();

  static UserManager _getInstance() {
    if (_instance == null) {
      _instance = new UserManager._internal();
    }
    return _instance;
  }

  Future<List<UserBean>> getUserFollower(String userName, int page) async {
    String url = Api.getUserFollower(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url, isCache: false);
    if (response != null && response.result) {
      List<UserBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(UserBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  Future<List<UserBean>> getUserFollowing(String userName, int page) async {
    String url = Api.getUserFollowing(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url, isCache: false);
    if (response != null && response.result) {
      List<UserBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(UserBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  Future<List<OrgBean>> getOrgs(String userName, int page) async {
    String url = Api.getOrgs(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url, isCache: false);
    if (response != null && response.result) {
      List<OrgBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(OrgBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  Future<UserBean> getUserInfo(String userName) async {
    final response =
        await HttpRequest().get(Api.getUserInfo(userName), isCache: false);
    if (response != null && response.data != null) {
      return UserBean.fromJson(response.data);
    }
    return null;
  }

  isFollow(userName) async {
    String url = Api.isFollow(userName);
    return await HttpRequest().get(url, isCache: false);
  }

  follow(userName) async {
    String url = Api.follow(userName);
    return await HttpRequest().put(url, isCache: false);
  }

  unFollow(userName) async {
    String url = Api.unFollow(userName);
    return await HttpRequest().delete(url, isCache: false);
  }

  Future<OrgBean> getOrgProfile(String org) async {
    final response =
        await HttpRequest().get(Api.getOrgProfile(org), isCache: false);
    if (response != null && response.data != null) {
      return OrgBean.fromJson(response.data);
    }
    return null;
  }

  Future<List<UserBean>> getOrgMembers(String userName, int page) async {
    String url = Api.getOrgMembers(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url, isCache: false);
    if (response != null && response.result) {
      List<UserBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(UserBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  bool isYou(String userName) {
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null && TextUtil.equals(userBean.login, userName)) {
      return true;
    }
    return false;
  }
}
