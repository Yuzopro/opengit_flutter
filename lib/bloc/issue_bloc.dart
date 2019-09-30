import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/common/sp_const.dart';
import 'package:open_git/manager/issue_manager.dart';

class IssueBloc extends BaseListBloc<IssueBean> {
  static final String TAG = 'IssueBloc';

  String filter, state, sort, direction;

  IssueBloc() {
    filter =
        SpUtil.instance.getString(SP_KEY_ISSUE_FILTER, defValue: 'assigned');
    state = SpUtil.instance.getString(SP_KEY_ISSUE_STATE, defValue: 'open');
    sort = SpUtil.instance.getString(SP_KEY_ISSUE_SORT, defValue: 'created');
    direction =
        SpUtil.instance.getString(SP_KEY_ISSUE_DIRECTION, defValue: 'desc');
  }

  initData(BuildContext context) async {
    onReload();
  }

  refreshData(
      {String filter, String state, String sort, String direction}) async {
    this.filter = filter ?? this.filter;
    this.state = state ?? this.state;
    this.sort = sort ?? this.sort;
    this.direction = direction ?? this.direction;

    page = 1;

    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchIssueList();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchIssueList();
  }

  Future _fetchIssueList() async {
    LogUtil.v('_fetchIssueList', tag: TAG);
    try {
      var result = await IssueManager.instance
          .getIssue(filter, state, sort, direction, page);
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
        bean.isError = true;
      }
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
