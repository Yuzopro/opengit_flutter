import 'package:flutter/widgets.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/log_util.dart';

abstract class TrendBloc extends BaseListBloc<TrendBean> {
  static final String TAG = "TrendBloc";

  final String trend;
  final String since;

  bool _isInit = false;

  TrendBloc(this.trend, {this.since});

  initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchTrendList();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchTrendList();
  }

  Future _fetchTrendList() async {
    LogUtil.v('_fetchTrendList', tag: TAG);
    try {
      var result = await ReposManager.instance.getTrend(since, trend);
      if (bean.data == null) {
        bean.data = List();
      }
      if (result != null) {
        bean.data.addAll(result);
      }
      sink.add(bean);
    } catch (_) {}
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
