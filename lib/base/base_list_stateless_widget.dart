import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/widget/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_stateless_widget.dart';

abstract class BaseListStatelessWidget<T, B extends BaseListBloc<T>>
    extends BaseStatelessWidget<B> {
  static final String TAG = "BaseListStatelessWidget";

  Widget builderItem(BuildContext context, T item);

  Widget buildFloatingActionButton(BuildContext context) {
    return null;
  }

  @override
  Widget buildWidget(BuildContext context) {
    final RefreshController _controller = new RefreshController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.requestRefresh();
    });

    return new StreamBuilder(
        stream: bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
          return new RefreshScaffold(
            isLoading: snapshot.data == null,
            controller: _controller,
            enablePullUp: true,
            onRefresh: () {
              return bloc.onRefresh(_controller);
            },
            onLoadMore: () {
              return bloc.onLoadMore(_controller);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              T model = snapshot.data[index];
              return builderItem(context, model);
            },
            floatingActionButton: buildFloatingActionButton(context),
          );
        });
  }
}
