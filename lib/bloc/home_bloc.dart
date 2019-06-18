import 'package:collection/collection.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/juejin_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeBloc extends BaseListBloc<Entrylist> {
  static final String TAG = "HomeBloc";

  List<Entrylist> _entryList;

  @override
  void initState() {
//    LogUtil.v("initState", tag: TAG);
//    Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
//          onRefresh();
//    });
  }

  Future onRefresh(RefreshController controller) {
    LogUtil.v("onRefresh", tag: TAG);
    super.onRefresh(controller);
    return _getData(controller, false);
  }

  Future onLoadMore(RefreshController controller) {
    LogUtil.v("onLoadMore", tag: TAG);
    super.onLoadMore(controller);
    return _getData(controller, true);
  }

  _getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return JueJinManager.instance.getJueJinList(page).then((list) {
      if (_entryList == null) {
        _entryList = new List();
      }
      if (page == 1) {
        _entryList.clear();
      }
      _entryList.addAll(list);
      sink.add(UnmodifiableListView<Entrylist>(_entryList));

      if (controller != null) {
        if (!isLoad) {
          controller.refreshCompleted();
          controller.loadComplete();
        } else {
          controller.loadComplete();
        }
      }
    }).catchError((_) {
      page--;
      if (controller != null) {
        controller.loadFailed();
      }
    });
  }
}
