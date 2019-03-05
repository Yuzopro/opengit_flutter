import 'package:flutter/material.dart';

class TrendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrendPageState();
  }
}

class _TrendPageState extends State<TrendPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("Trend page"),
      ),
    );
  }
}
