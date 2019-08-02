import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';

class IssueBloc extends BaseListBloc<IssueBean> {
  static final String TAG = "IssueBloc";

  final String userName;
  String q, state, sort, order;

  bool _isInit = false;

  IssueBloc(this.userName) {
    q = "involves";
    state = "open";
    sort = "created";
    order = "asc";
  }

  @override
  PageType getPageType() {
    return PageType.issue;
  }

  initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    onReload();
  }

  refreshData({String q, String state, String sort, String order}) async {
    this.q = q ?? this.q;
    this.state = state ?? this.state;
    this.sort = sort ?? this.sort;
    this.order = order ?? this.order;

    page = 1;

    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchIssueList();
    hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchIssueList();
  }

  Future _fetchIssueList() async {
    LogUtil.v('_fetchIssueList', tag: TAG);
    try {
      var result = await IssueManager.instance
          .getIssue(q, state, sort, order, userName, page);
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

      sink.add(bean);
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
