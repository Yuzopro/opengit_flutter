import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_bloc.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/refresh_scaffold.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseStatelessWidget<T, B extends BaseBloc<T>>
    extends StatelessWidget {
  static final String TAG = "BaseStatelessWidget";

  ListPageType getListPageType();

  String getTitle(BuildContext context) {
    return "";
  }

  bool isShowAppBar() {
    return true;
  }

  bool enablePullUp() {
    return false;
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return null;
  }

  Widget getHeader(BuildContext context) {
    return null;
  }

  int getItemCount(T data) {
    return 0;
  }

  Widget buildItemBuilder(BuildContext context, T data, int index) {
    return null;
  }

  Widget getChild(BuildContext context, T data) {
    return null;
  }

  T initialData() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    B bloc = BlocProvider.of<B>(context);
    bloc.initData(context);

    return new Scaffold(
      appBar: isShowAppBar()
          ? new AppBar(
              elevation: 0,
              title: new Text(getTitle(context)),
            )
          : null,
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, B bloc) {
    RefreshController controller = new RefreshController();

    bloc.statusStream.listen((event) {
      if (event.type == getListPageType()) {
        //to-do 该页面在不触发刷新时也会回调
        LogUtil.v('page is ${event.page}@type is ${event.type}', tag: TAG);
        if (event.page == 1) {
          controller.refreshCompleted();
          if (event.noMore) {
            controller.loadNoData();
          }
        } else if (event.noMore) {
          controller.loadNoData();
        } else {
          controller.loadComplete();
        }
      }
    });

    return new StreamBuilder(
        stream: bloc.stream,
        initialData: initialData(),
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          LogUtil.v('${getListPageType().toString()} receiver data', tag: TAG);
          return new RefreshScaffold(
            isLoading: snapshot.data == null,
            controller: controller,
            enablePullUp: enablePullUp(),
            onRefresh: () {
              bloc.onRefresh();
            },
            onLoadMore: () {
              bloc.onLoadMore();
            },
            itemCount: getItemCount(snapshot.data),
            itemBuilder: (BuildContext context, int index) {
              return buildItemBuilder(context, snapshot.data, index);
            },
            floatingActionButton: buildFloatingActionButton(context),
            header: getHeader(context),
            child: getChild(context, snapshot.data),
          );
        });
  }
}
