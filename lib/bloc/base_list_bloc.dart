import 'package:open_git/bean/loading_bean.dart';
import 'package:open_git/bloc/base_bloc.dart';

abstract class BaseListBloc<T> extends BaseBloc<LoadingBean<List<T>>> {
  LoadingBean<List<T>> bean;

  BaseListBloc() {
    bean = new LoadingBean(isLoading: false, data: []);
  }

  void onRefresh() async {
    page = 1;
    super.onRefresh();
  }

  void onLoadMore() async {
    page++;
    super.onLoadMore();
  }
}
