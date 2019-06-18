import 'package:open_git/bloc/base_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListBloc<T> extends BaseBloc<List<T>> {
  int page = 1;

  Future onRefresh(RefreshController controller) {
    page = 1;
  }

  Future onLoadMore(RefreshController controller) {
    page++;
  }
}
