import 'dart:convert';

import 'package:open_git/bean/login_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/contract/login_contract.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/util/shared_prf_util.dart';

class LoginPresenter extends ILoginPresenter {
  @override
  void login(String name, String password) {
    LoginManager.instance.login(name, password, (data) {
      if (data != null) {
        LoginBean loginBean = LoginBean.fromJson(data);
        if (loginBean != null) {
          String token = loginBean.token;
          LoginManager.instance.setToken(token);
          SharedPrfUtils.saveString(SharedPrfKey.SP_KEY_TOKEN, token);

          //获取自己的用户信息
          getMyUserInfo();
        }
      }
    }, (code, msg) {
      if (view != null) {
        view.showToast("code is $code @msg is $msg");
      }
    });
  }

  @override
  void getMyUserInfo() {
    LoginManager.instance.getMyUserInfo((data) {
      if (data != null) {
        //缓存用户信息
        SharedPrfUtils.saveString(SharedPrfKey.SP_KEY_USER_INFO, jsonEncode(data));
        LoginManager.instance.setUserBean(data);

        UserBean userBean = UserBean.fromJson(data);
        if (userBean != null && view != null) {
          view.onLoginSuccess();
        }
      }
    }, (code, msg) {
      if (view != null) {
        view.showToast("code is $code @msg is $msg");
      }
    });
  }
}
