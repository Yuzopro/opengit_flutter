import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';

class TimelineBloc extends BaseListBloc<ReleaseBean> {
  static final String TAG = "TimelineBloc";

  @override
  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchTimeline();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchTimeline();
  }

  Future _fetchTimeline() async {
    LogUtil.v('_fetchReposList', tag: TAG);
    try {
      var result = await ReposManager.instance
          .getReposReleases('Yuzopro', 'OpenGit_Flutter', page: page);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        bean.isError = false;
        noMore = result.length != Config.PAGE_SIZE;
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
    } catch (_) {
      if (page > 1) {
        page--;
      }
    }
  }
}
