import 'package:flutter/material.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({Key key, this.title, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          new PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        value: "browser",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
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
                            ))),
                  ])
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {},
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
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
