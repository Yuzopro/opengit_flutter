import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/user/user_action.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/locale_util.dart';
import 'package:open_git/util/theme_util.dart';
import 'package:open_git/util/timer_util.dart';
import 'package:redux/redux.dart';

class UserMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "UserMiddleware";

  TimerUtil _timerUtil;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is InitAction) {
      _init(store, next);
    } else if (action is StartCountdownAction) {
      startCountdown(store, next, action.context);
    } else if (action is StopCountdownAction) {
      _cancelTimer();
    } else {
      next(action);
    }
  }

  Future<Null> _init(Store<AppState> store, NextDispatcher next) async {
    await SpUtil.instance.init();

    CacheProvider provider = CacheProvider();
    await provider.delete();

    //主题
    int theme =
        SpUtil.instance.getInt(SharedPrfKey.SP_KEY_THEME_COLOR);
    if (theme != 0) {
      Color color = new Color(theme);
      next(RefreshThemeDataAction(AppTheme.changeTheme(color)));
    }
    //语言
    int locale =
        SpUtil.instance.getInt(SharedPrfKey.SP_KEY_LANGUAGE_COLOR);
    if (locale != 0) {
      next(RefreshLocalAction(LocaleUtil.changeLocale(store.state, locale)));
    }
    //用户信息
    String token =
        SpUtil.instance.getString(SharedPrfKey.SP_KEY_TOKEN);
    UserBean userBean = null;
    var user =
        SpUtil.instance.getObject(SharedPrfKey.SP_KEY_USER_INFO);
    if (user != null) {
      LoginManager.instance.setUserBean(user, false);
      userBean = UserBean.fromJson(user);
    }
    LoginManager.instance.setToken(token, false);
    //引导页
    String version = SpUtil.instance
        .getString(SharedPrfKey.SP_KEY_SHOW_GUIDE_VERSION);
    String currentVersion = Config.SHOW_GUIDE_VERSION;
    next(InitCompleteAction(token, userBean, currentVersion != version));

    ReposManager.instance.initLanguageColors();
  }

  void startCountdown(
      Store<AppState> store, NextDispatcher next, BuildContext context) {
    _timerUtil = new TimerUtil(mTotalTime: 3 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      next(CountdownAction(_tick.toInt()));
      if (_tick == 0) {
        _cancelTimer();

        _jump(context, store.state.userState.status,
            store.state.userState.isGuide);
      }
    });
    _timerUtil.startCountDown();
  }

  void _jump(BuildContext context, LoginStatus status, bool isShowGuide) {
    if (isShowGuide) {
      NavigatorUtil.goGuide(context);
    } else if (status == LoginStatus.success) {
      NavigatorUtil.goMain(context);
    } else if (status == LoginStatus.error) {
      NavigatorUtil.goLogin(context);
    }
  }

  void _cancelTimer() {
    if (_timerUtil != null) {
      _timerUtil.cancel();
      _timerUtil = null;
    }
  }
}
