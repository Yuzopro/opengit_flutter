import 'package:flutter/material.dart';

class AppInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppInfoPageState();
  }
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("AppInfo page"),
      ),
    );
  }
}
