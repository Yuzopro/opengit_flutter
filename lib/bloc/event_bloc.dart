import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/common/config.dart';

abstract class EventBloc extends BaseListBloc<EventBean> {
  static final String TAG = "EventBloc";

  final String userName;

  EventBloc(this.userName);

  bool _isInit = false;

  fetchEvent(int page);

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
    await _fetchEventList();
    hideLoading();

    refreshStatusEvent();
  }

  @override
  Future getData() async {
    await _fetchEventList();
  }

  Future _fetchEventList() async {
    LogUtil.v('_fetchEventList', tag: TAG);
    try {
      var result = await fetchEvent(page);
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
