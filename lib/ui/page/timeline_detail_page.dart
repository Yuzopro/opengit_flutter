import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';

class TimelineDetailPage extends StatelessWidget {
  final String title;
  final String body;

  const TimelineDetailPage({Key key, this.title, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: YZConstant.normalTextWhite,
        ),
      ),
      body: Text(body),
    );
  }
}
