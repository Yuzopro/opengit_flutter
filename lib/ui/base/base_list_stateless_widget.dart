import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/bean/loading_bean.dart';
import 'package:open_git/ui/base/base_stateless_widget.dart';

abstract class BaseListStatelessWidget<T, B extends BaseListBloc<T>>
    extends BaseStatelessWidget<LoadingBean<List<T>>, B> {
  static final String TAG = "BaseListStatelessWidget";

  Widget builderItem(BuildContext context, T item);


  bool enablePullUp() {
    return true;
  }

  @override
  bool isLoading(LoadingBean<List<T>> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  int getItemCount(LoadingBean<List<T>> data) {
    if (data == null) {
      return 0;
    }
    return data.data == null ? 0 : data.data.length;
  }

  @override
  Widget buildItemBuilder(
      BuildContext context, LoadingBean<List<T>> data, int index) {
    T model = data.data[index];
    return builderItem(context, model);
  }
}
