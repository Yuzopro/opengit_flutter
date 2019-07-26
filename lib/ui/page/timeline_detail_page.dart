import 'package:flutter/material.dart';
import 'package:open_git/util/common_util.dart';

class TimelineDetailPage extends StatelessWidget {
  final String title;
  final String body;

  const TimelineDetailPage({Key key, this.title, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar(title),
      body: Text(body),
    );
  }
}
