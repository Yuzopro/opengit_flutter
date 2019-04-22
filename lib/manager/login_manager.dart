import 'dart:convert';

import 'package:open_git/bean/login_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/credentials.dart';
import 'package:open_git/http/http_manager.dart';
import 'package:open_git/util/shared_prf_util.dart';

class LoginManager {
  factory LoginManager() => _getInstance();

  static LoginManager get instance => _getInstance();
  static LoginManager _instance;

  String _token;
  UserBean _userBean;

  LoginManager._internal() {}

  static LoginManager _getInstance() {
    if (_instance == null) {
      _instance = new LoginManager._internal();
    }
    return _instance;
  }

  initData() {
    _initToken();
    return _initUserInfo();
  }

  _initToken() async {
    _token = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_TOKEN);
  }

  _initUserInfo() async {
    var user = await SharedPrfUtils.get(SharedPrfKey.SP_KEY_USER_INFO);
    if (user != null) {
      var userMap = jsonDecode(user);
      setUserBean(userMap);
      return _userBean;
    }
  }

  setUserBean(data) {
    if (data == null) {
      _userBean = null;
    } else {
      _userBean = UserBean.fromJson(data);
    }
  }

  getUserBean() {
    return _userBean;
  }

  void setToken (String token) {
    _token = token;
  }

  String getToken() {
    String auth = _token;
    if (_token != null && _token.length > 0) {
      auth = _token.startsWith("Basic") ? _token : "token " + _token;
    }
    return auth;
  }

  login(String userName, String password) async {
    _token = Credentials.basic(userName, password);

    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": "1d1d0f0e84625e416efb",
      "client_secret": "d8cb03c0f6dc85ebf610077148b0471aa66f1b42"
    };
    final response = await HttpManager.doPost(Api.authorizations(), requestParams, null);
    if (response != null && response.data != null) {
      LoginBean loginBean = LoginBean.fromJson(response.data);
      if (loginBean != null) {
        String token = loginBean.token;
        LoginManager.instance.setToken(token);
        SharedPrfUtils.saveString(SharedPrfKey.SP_KEY_TOKEN, token);

        //获取自己的用户信息
        return await getMyUserInfo();
      }
    }
    return null;
  }

  getMyUserInfo() async {
    final response = await HttpManager.doGet(Api.getMyUserInfo(), null);
    if (response != null && response.data != null) {
      //缓存用户信息
      SharedPrfUtils.saveString(
          SharedPrfKey.SP_KEY_USER_INFO, jsonEncode(response.data));
      LoginManager.instance.setUserBean(response.data);

      return UserBean.fromJson(response.data);
    }
    return null;
  }
}
