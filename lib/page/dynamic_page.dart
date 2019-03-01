import 'package:flutter/material.dart';

class DynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DynamicPageState();
  }
}

class _DynamicPageState extends State<DynamicPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("dynamic page"),
    );
  }
}
