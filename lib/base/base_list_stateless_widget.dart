import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/ui/widget/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_stateless_widget.dart';

abstract class BaseListStatelessWidget<T, B extends BaseListBloc<T>>
    extends BaseStatelessWidget<B> {
  static final String TAG = "BaseListStatelessWidget";

  RefreshController controller;

  Widget builderItem(BuildContext context, T item);

  Widget buildFloatingActionButton(BuildContext context) {
    return null;
  }

  Widget getHeader(BuildContext context) {
    return null;
  }

  void requestRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.position != null) {
        controller.requestRefresh();
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    controller = new RefreshController();

    requestRefresh();

    return new StreamBuilder(
        stream: bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
          //每进入或退出一个页面该地方都会刷新？？？
          return new RefreshScaffold(
            isLoading: snapshot.data == null,
            controller: controller,
            enablePullUp: true,
            onRefresh: () {
              return bloc.onRefresh(controller);
            },
            onLoadMore: () {
              return bloc.onLoadMore(controller);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              T model = snapshot.data[index];
              return builderItem(context, model);
            },
            floatingActionButton: buildFloatingActionButton(context),
            header: getHeader(context),
          );
        });
  }
}
