import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/user_manager.dart';

class ProfileBloc extends BaseBloc<LoadingBean<UserBean>> {
  final String name;

  ProfileBloc(this.name) {
    bean = new LoadingBean(isLoading: false);
  }

  @override
  void initData(BuildContext context) {
    onReload();
  }

  void followOrUnFollow() async {
    showLoading();
    if (bean.data.isFollow) {
      await _unFollow();
    } else {
      await _follow();
    }
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchProfile();
    await _fetchFollow();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchProfile();
    await _fetchFollow();
    hideLoading();
  }

  Future _fetchProfile() async {
    final result = await UserManager.instance.getUserInfo(name);
    bean.data = result;

    if (result == null) {
      bean.isError = true;
    } else {
      bean.isError = false;
    }
  }

  Future _fetchFollow() async {
    if (!UserManager.instance.isYou(name) && bean.data != null) {
      final response = await UserManager.instance.isFollow(name);
      bool isFollow = false;
      if (response != null && response.result) {
        isFollow = true;
      }
      bean.data.isFollow = isFollow;
    }
  }

  Future _follow() async {
    final response = await UserManager.instance.follow(name);
    if (response != null && response.result) {
      bean.data.isFollow = true;
    } else {
      ToastUtil.showMessgae('操作失败请重试');
    }
  }

  Future _unFollow() async {
    final response = await UserManager.instance.unFollow(name);
    if (response != null && response.result) {
      bean.data.isFollow = false;
    } else {
      ToastUtil.showMessgae('操作失败请重试');
    }
  }
}
