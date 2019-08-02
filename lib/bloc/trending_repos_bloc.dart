import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_repos_bean.dart';
import 'package:open_git/manager/trending_manager.dart';

class TrendingReposBloc extends BaseListBloc<TrendingReposBean> {
  static final String TAG = "TrendingReposBloc";

  String language, since;

  bool _isInit = false;

  TrendingReposBloc(this.language, this.since);

  @override
  PageType getPageType() {
    return PageType.trending_repos;
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchTrendList();
    hideLoading();

    refreshStatusEvent();
  }

  void refreshData({String language, String since}) async {
    this.language = language ?? this.language;
    this.since = since ?? this.since;

    showLoading();
    await _fetchTrendList();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchTrendList();
  }

  Future _fetchTrendList() async {
    LogUtil.v('_fetchTrendList', tag: TAG);
    try {
      var result = await TrendingManager.instance.getRepos(language, since);
      if (bean.data == null) {
        bean.data = List();
      }
      bean.data.clear();
      if (result != null) {
        bean.isError = false;
        bean.data.addAll(result);
      } else {
        bean.isError = true;
      }
      sink.add(bean);
    } catch (_) {}
  }
}
