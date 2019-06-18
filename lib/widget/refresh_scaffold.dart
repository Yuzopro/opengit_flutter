import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshScaffold extends StatefulWidget {
  const RefreshScaffold(
      {Key key,
      this.isLoading,
      @required this.controller,
      this.enablePullUp: true,
      this.onRefresh,
      this.onLoadMore,
      this.child,
      this.itemCount,
      this.itemBuilder,
      this.floatingActionButton})
      : super(key: key);

  final bool isLoading;
  final RefreshController controller;
  final bool enablePullUp;
  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget floatingActionButton;

  @override
  State<StatefulWidget> createState() {
    return new RefreshScaffoldState();
  }
}

class RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

  static final String TAG = "RefreshScaffold";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.scrollController.addListener(() {
        int offset = widget.controller.scrollController.offset.toInt();
        if (offset < 480 && isShowFloatBtn) {
          isShowFloatBtn = false;
          setState(() {});
        } else if (offset > 480 && !isShowFloatBtn) {
          isShowFloatBtn = true;
          setState(() {});
        }
      });
    });
  }

  Widget buildFloatingActionButton() {
    if (widget.controller.scrollController == null ||
        widget.controller.scrollController.offset < 480) {
      return null;
    }

    return new FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          widget.controller.scrollController.animateTo(0.0,
              duration: new Duration(milliseconds: 300), curve: Curves.linear);
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            new SmartRefresher(
                controller: widget.controller,
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
                enablePullUp: widget.enablePullUp,
                onRefresh: widget.onRefresh,
                onLoading: widget.onLoadMore,
                child: widget.child ??
                    new ListView.builder(
                      itemCount: widget.isLoading ? 0 : widget.itemCount,
                      itemBuilder: widget.itemBuilder,
                    )),
            new Offstage(
              offstage: widget.isLoading != true,
              child: new Container(
                alignment: Alignment.center,
                child: new Center(
                  child: Text("数据暂时为空"),
                ),
              ),
            )
          ],
        ),
        floatingActionButton:
            widget.floatingActionButton ?? buildFloatingActionButton());
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller != null) {
      widget.controller.dispose();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
