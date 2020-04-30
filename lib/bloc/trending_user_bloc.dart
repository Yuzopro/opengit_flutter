import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_user_bean.dart';
import 'package:open_git/manager/trending_manager.dart';

class TrendingUserBloc extends BaseListBloc<TrendingUserBean> {
  static final String TAG = "TrendingUserBloc";

  String language, since;

  TrendingUserBloc(this.language, this.since);

  @override
  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchTrendList();
    hideLoading();
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
      var result = await TrendingManager.instance.getUser(language, since);
      if (bean.data == null) {
        bean.data = List();
      }
      bean.data.clear();
      if (result != null) {
        bean.isError = false;
        bean.data.addAll(result);
      } else {
        if (bean.data.length > 0) {
          bean.isError = false;
          noMore = false;
        } else {
          bean.isError = true;
        }
        if (page > 1) {
          page--;
        }
      }
    } catch (_) {}
  }
}
