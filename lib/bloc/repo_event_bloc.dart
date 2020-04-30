import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoEventBloc extends BaseListBloc<EventBean> {
  final String reposOwner;
  final String reposName;

  RepoEventBloc(this.reposOwner, this.reposName);

  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchEventList();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchEventList();
  }

  Future _fetchEventList() async {
    try {
      var result = await ReposManager.instance
          .getReposEvents(reposOwner, reposName, page);
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
