import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/track_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/db/read_record_provider.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

class TrackBloc extends BaseListBloc<TrackBean> {
  @override
  void initData(BuildContext context) {
    onReload();
  }

  @override
  Future getData() async {
    await _fetchTrack();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchTrack();
    hideLoading();
  }

  Future _fetchTrack() async {
    LogUtil.v('_fetchTrack');

    int date = DateTime.now().millisecondsSinceEpoch;
    if (bean.data != null && bean.data.length > 0 && page > 1) {
      int size = bean.data.length;
      TrackBean trackBean = bean.data[size -1];
      date = trackBean.date;
    }

    var result = await ReadRecordProvider().query(date);
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
  }
}
