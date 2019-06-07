import 'package:flutter/material.dart';

class IntroductionDetailPage extends StatelessWidget {
  final String title;
  final String body;

  const IntroductionDetailPage({Key key, this.title, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          title,
        ),
      ),
      body: new Center(
        child: new Text(body),
      ),
    );
  }
}
