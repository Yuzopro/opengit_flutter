import 'package:flutter/widgets.dart';
import 'package:open_git/bean/login_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:open_git/util/toast_util.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "LoginMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchLoginAction) {
      _doLogin(next, action.context, action.userName, action.password);
    }
  }

  Future<void> _doLogin(NextDispatcher next, BuildContext context,
      String userName, String password) async {
    next(RequestingLoginAction());

    try {
      LoginBean loginBean =
          await LoginManager.instance.login(userName, password);
      if (loginBean != null) {
        String token = loginBean.token;
        LoginManager.instance.setToken(loginBean.token, true);
        UserBean userBean = await LoginManager.instance.getMyUserInfo();
        if (userBean != null) {
          next(InitCompleteAction(token, userBean));
          next(ReceivedLoginAction(token, userBean));
          NavigatorUtil.goMain(context);
        } else {
          ToastUtil.showToast('登录失败请重新登录');
          LoginManager.instance.setToken(null, true);
        }
      } else {
        ToastUtil.showToast('登录失败请重新登录');
        next(ErrorLoadingLoginAction());
      }
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      ToastUtil.showToast('登录失败请重新登录');
      next(ErrorLoadingLoginAction());
    }
  }
}
