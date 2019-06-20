import 'package:open_git/bloc/base_bloc.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListBloc<T> extends BaseBloc<List<T>> {
  static final String TAG = "BaseListBloc";

  List<T> list;

  int page = 1;

  Future getData(RefreshController controller, bool isLoad);

  Future onRefresh(RefreshController controller) {
    LogUtil.v("onRefresh", tag: TAG);
    page = 1;
    return getData(controller, false);
  }

  Future onLoadMore(RefreshController controller) {
    LogUtil.v("onLoadMore", tag: TAG);
    page++;
    return getData(controller, true);
  }
}
