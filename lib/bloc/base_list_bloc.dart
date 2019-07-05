import 'package:open_git/bloc/base_bloc.dart';

abstract class BaseListBloc<T> extends BaseBloc<List<T>> {
  List<T> list;

  void onRefresh() async {
    page = 1;
    super.onRefresh();
  }

  void onLoadMore() async {
    page++;
    super.onLoadMore();
  }
}
