import 'package:flutter/widgets.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/util/log_util.dart';

abstract class FollowBloc extends BaseListBloc<UserBean> {
  static final String TAG = "FollowBloc";

  final String userName;

  bool _isInit = false;

  FollowBloc(this.userName);

  fetchList(String userName, int page);

  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchFollowList();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchFollowList();
  }

  Future _fetchFollowList() async {
    LogUtil.v('_fetchFollowList', tag: TAG);
    try {
      var result = await fetchList(userName, page);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      }

      sink.add(bean);
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }

  void _showLoading() {
    bean.isLoading = true;
    sink.add(bean);
  }

  void _hideLoading() {
    bean.isLoading = false;
    sink.add(bean);
  }
}
