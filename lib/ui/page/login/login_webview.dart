import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginWebView extends StatefulWidget {
  final String url;

  LoginWebView(this.url);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  // _renderTitle() {
  //   return new Row(children: [
  //     new Expanded(
  //         child: new Container(
  //       child: new Text(
  //         widget.title,
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     )),
  //   ]);
  // }

  renderLoading() {
    return new Center(
      child: new Container(
        width: 200.0,
        height: 200.0,
        padding: new EdgeInsets.all(4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            new Container(width: 10.0),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.shouldStart) {
          if (state.url != null && state.url.startsWith("opengitapp://authed")) {
            var code = Uri.parse(state.url).queryParameters["code"];
            print("code ${code}");
            flutterWebViewPlugin.reloadUrl("about:blank");
            Navigator.of(context).pop(code);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          WebviewScaffold(
            //invalidUrlRegex: "gsygithubapp://authed",
            initialChild: renderLoading(),
            url: widget.url,
          ),
        ],
      ),
    );
  }
}
