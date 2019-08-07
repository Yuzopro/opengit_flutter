import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/common_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CodeDetailPageWeb extends StatefulWidget {
  final String title;

  final String htmlUrl;

  CodeDetailPageWeb({this.title, this.htmlUrl});

  @override
  _CodeDetailPageState createState() => _CodeDetailPageState();
}

class _CodeDetailPageState extends State<CodeDetailPageWeb> {
  String data;

  _CodeDetailPageState();

  @override
  void initState() {
    super.initState();
    if (data == null) {
      ReposManager.instance.getCodeDetail(widget.htmlUrl).then((res) {
        setState(() {
          this.data = res;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        appBar:CommonUtil.getAppBar(widget.title),
        body: Container(
          alignment: Alignment.center,
          child: Center(
            child: SpinKitCircle(
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CommonUtil.getAppBar(widget.title),
      body: WebView(
        initialUrl: data,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
