import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart' as app;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class YZPullRefreshList extends StatefulWidget {
  static final String TAG = "YZRefreshScaffold";

  final LoadingStatus status;
  final app.RefreshStatus refreshStatus;
  final Function onRefreshCallback, onLoadCallback;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget floatingActionButton;
  final bool enablePullUp;
  final bool enablePullDown;
  final String title;
  final Widget child;

  YZPullRefreshList(
      {this.status,
      this.refreshStatus,
      this.onRefreshCallback,
      this.onLoadCallback,
      this.itemCount,
      this.itemBuilder,
      this.floatingActionButton,
      this.enablePullUp: true,
      this.enablePullDown: true,
      this.title,
      this.child});

  @override
  State<StatefulWidget> createState() {
    return YZPullRefreshListState();
  }
}

class YZPullRefreshListState extends State<YZPullRefreshList>
    with AutomaticKeepAliveClientMixin {
  RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.refreshStatus == app.RefreshStatus.refresh) {
      controller.refreshCompleted();
    } else if (widget.refreshStatus == app.RefreshStatus.refresh_no_data) {
      controller.refreshCompleted();
      controller.loadNoData();
    } else if (widget.refreshStatus == app.RefreshStatus.loading) {
      controller.loadComplete();
    } else if (widget.refreshStatus == app.RefreshStatus.loading_no_data) {
      controller.loadNoData();
    }

    return new Scaffold(
      appBar: widget.title != null
          ? new AppBar(
              title: new Text(widget.title),
            )
          : null,
      body: new Stack(
        children: <Widget>[
          new SmartRefresher(
              controller: controller,
              header: MaterialClassicHeader(
                color: Colors.black,
              ),
              footer: ClassicFooter(
                loadingIcon: SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                ),
              ),
              enablePullDown: widget.enablePullDown,
              enablePullUp: widget.enablePullUp,
              onRefresh: widget.onRefreshCallback,
              onLoading: widget.onLoadCallback,
              child: widget.child != null
                  ? widget.child
                  : new ListView.builder(
                      itemCount: widget.itemCount,
                      itemBuilder: widget.itemBuilder,
                    )),
          new Offstage(
            offstage: widget.status != LoadingStatus.loading,
            child: new Container(
              alignment: Alignment.center,
              child: new Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
      controller = null;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
