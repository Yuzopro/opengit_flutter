import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final bool isAd;

  const WebViewPage({Key key, this.title, this.url, this.isAd: false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: widget.isAd
            ? null
            : AppBar(
                title: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                actions: <Widget>[
                  PopupMenuButton(
                      padding: const EdgeInsets.all(0.0),
                      onSelected: _onPopSelected,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                              value: "browser",
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                dense: false,
                                title: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.language,
                                        color: Colors.grey,
                                        size: 22.0,
                                      ),
                                      Text(
                                        '浏览器打开',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                ],
              ),
        body: WebView(
          onWebViewCreated: (WebViewController webViewController) {},
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      onWillPop: () {
        if (widget.isAd) {
          Store<AppState> store = StoreProvider.of(context);
          LoginStatus status = store.state.userState.status;
          if (store.state.userState.isGuide) {
            NavigatorUtil.goGuide(context);
          } else if (status == LoginStatus.success) {
            NavigatorUtil.goMain(context);
          } else if (status == LoginStatus.error) {
            NavigatorUtil.goLogin(context);
          }
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
    );
  }

  void _onPopSelected(String value) {
    switch (value) {
      case "browser":
        NavigatorUtil.launchInBrowser(widget.url, title: widget.title);
        break;
      default:
        break;
    }
  }
}
