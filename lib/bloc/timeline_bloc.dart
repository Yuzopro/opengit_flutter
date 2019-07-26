import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

class TimelineBloc extends BaseListBloc<ReleaseBean> {
  static final String TAG = "TimelineBloc";

  bool _isInit = false;

  @override
  PageType getPageType() {
    return PageType.timeline;
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchTimeline();
    _hideLoading();

    refreshStatusEvent();
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
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      } else {
        bean.isError = true;
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
