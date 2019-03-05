import 'package:flutter/material.dart';

class IssuePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IssuePageState();
  }
}

class _IssuePageState extends State<IssuePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("issue page"),
    );
  }
}
