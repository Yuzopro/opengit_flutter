import 'package:flutter/widgets.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/login_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/redux/user/user_action.dart';
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
        LoginManager.instance.setToken(token, true);
        next(FetchUserAction(context, token));
      } else {
        ToastUtil.showMessgae('登录失败请重新登录');
        next(ErrorLoadingLoginAction());
      }
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      ToastUtil.showMessgae('登录失败请重新登录');
      next(ErrorLoadingLoginAction());
    }
  }
}
