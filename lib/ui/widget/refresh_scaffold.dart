import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshScaffold extends StatefulWidget {
  const RefreshScaffold(
      {Key key,
      this.isLoading,
      @required this.controller,
      this.enablePullDown: true,
      this.enablePullUp: true,
      this.onRefresh,
      this.onLoadMore,
      this.child,
      this.itemCount,
      this.itemBuilder,
      this.floatingActionButton,
      this.header})
      : super(key: key);

  final bool isLoading;
  final RefreshController controller;
  final bool enablePullDown, enablePullUp;
  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget floatingActionButton;
  final Widget header;

  @override
  State<StatefulWidget> createState() {
    return RefreshScaffoldState();
  }
}

class RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

  static final String TAG = "RefreshScaffold";

//  @override
//  void initState() {
//    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      widget.controller.scrollController.addListener(() {
//        int offset = widget.controller.scrollController.offset.toInt();
//        if (offset < 480 && isShowFloatBtn) {
//          isShowFloatBtn = false;
//          setState(() {});
//        } else if (offset > 480 && !isShowFloatBtn) {
//          isShowFloatBtn = true;
//          setState(() {});
//        }
//      });
//    });
//  }

//  Widget buildFloatingActionButton() {
//    if (widget.controller.scrollController == null ||
//        widget.controller.scrollController.offset < 480) {
//      return null;
//    }
//
//    return FloatingActionButton(
//        backgroundColor: Theme.of(context).primaryColor,
//        child: Icon(
//          Icons.keyboard_arrow_up,
//        ),
//        onPressed: () {
//          widget.controller.scrollController.animateTo(0.0,
//              duration: Duration(milliseconds: 300), curve: Curves.linear);
//        });
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    int itemCount =
        widget.header == null ? widget.itemCount : widget.itemCount + 1;

    return Scaffold(
        body: Stack(
          children: <Widget>[
            SmartRefresher(
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
                enablePullDown: widget.enablePullDown,
                enablePullUp: widget.enablePullUp,
                onRefresh: widget.onRefresh,
                onLoading: widget.onLoadMore,
                child: widget.child ??
                    ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.header != null && index == 0) {
                          return widget.header;
                        }
                        return widget.itemBuilder(
                            context, widget.header == null ? index : index - 1);
                      },
                    )),
            Offstage(
              offstage: !widget.isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
                child: Center(
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: widget.itemCount != 0 || widget.isLoading,
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        Image(
                            width: 64.0,
                            height: 64.0,
                            image: AssetImage('image/ic_launcher.png')),
                        SizedBox(height: 5.0),
                        Text('暂无数据'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton:
            widget.floatingActionButton /*?? buildFloatingActionButton()*/);
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
