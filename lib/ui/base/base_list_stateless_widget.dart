import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_list_bloc.dart';

import 'package:open_git/ui/base/base_stateless_widget.dart';

abstract class BaseListStatelessWidget<T, B extends BaseListBloc<T>>
    extends BaseStatelessWidget<List<T>, B> {
  static final String TAG = "BaseListStatelessWidget";

  Widget builderItem(BuildContext context, T item);

  bool enablePullUp() {
    return true;
  }

  @override
  int getItemCount(List<T> data) {
    return data == null ? 0 : data.length;
  }

  @override
  Widget buildItemBuilder(BuildContext context, List<T> data, int index) {
    T model = data[index];
    return builderItem(context, model);
  }
}
