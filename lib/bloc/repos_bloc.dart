import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';

abstract class ReposBloc extends BaseListBloc<Repository> {
  static final String TAG = "ReposBloc";

  final String userName;
  final bool isStar;

  ReposBloc(this.userName, {this.isStar}) {
  }

  bool _isInit = false;

  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchReposList();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchReposList();
  }

  Future _fetchReposList() async {
    LogUtil.v('_fetchReposList', tag: TAG);
    try {
      var result =
          await ReposManager.instance.getUserRepos(userName, page, null, isStar);
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
