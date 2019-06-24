import 'package:flutter/material.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/refresh_status.dart' as refresh_status;
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class YZPullRefreshList extends StatelessWidget {
  static final String TAG = "YZRefreshScaffold";

  final LoadingStatus status;
  final refresh_status.RefreshStatus refreshStatus;
  final Function onRefreshCallback, onLoadCallback;
  final RefreshController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget floatingActionButton;

  YZPullRefreshList(
      {this.status,
      this.refreshStatus,
      this.onRefreshCallback,
      this.onLoadCallback,
      this.controller,
      this.itemCount,
      this.itemBuilder,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    LogUtil.v(refreshStatus.toString() + "@" + status.toString(), tag: TAG);

    if (refreshStatus == refresh_status.RefreshStatus.refresh) {
      controller.refreshCompleted();
    } else if (refreshStatus == refresh_status.RefreshStatus.refresh_no_data) {
      controller.refreshCompleted();
      controller.loadNoData();
    } else if (refreshStatus == refresh_status.RefreshStatus.loading) {
      controller.loadComplete();
    } else if (refreshStatus == refresh_status.RefreshStatus.loading_no_data) {
      controller.loadNoData();
    }

    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new SmartRefresher(
              controller: controller,
              header: MaterialClassicHeader(
                color: Colors.black,
              ),
              footer: ClassicFooter(
                loadingIcon: const SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.black)),
                ),
              ),
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: onRefreshCallback,
              onLoading: onLoadCallback,
              child: new ListView.builder(
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              )),
          new Offstage(
            offstage: status != LoadingStatus.loading,
            child: new Container(
              alignment: Alignment.center,
              child: new Center(
                child: const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.black)),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
